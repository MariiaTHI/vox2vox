import h5py
import numpy as np
import matplotlib.pyplot as plt
import imageio
import torch
import sys
import os
from PIL import Image

def read_vox_file(file_path):
    print(f"Attempting to read file: {file_path}")
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"File does not exist: {file_path}")
    try:
        with h5py.File(file_path, 'r') as file:
            data = file['data'][()]
        print(f"Shape of data read from {file_path}: {data.shape}")
        return data
    except Exception as e:
        raise Exception(f"Error reading {file_path}: {e}")

def qspace_to_rspace(qspace_data):
    print(f"Converting q-space to r-space. Input shape: {qspace_data.shape}")
    try:
        if qspace_data.shape[0] == 1:
            qspace_data = qspace_data[0]
        complex_data = qspace_data[0] + 1j * qspace_data[1]
        rspace_data = np.fft.ifftn(complex_data)
        print(f"Converted to r-space. Output shape: {rspace_data.shape}")
        return np.real(rspace_data)
    except Exception as e:
        raise Exception(f"Error in qspace_to_rspace: {e}")

def load_generator(checkpoint_path, in_channels=2, out_channels=2):
    print(f"Loading generator from: {checkpoint_path}")
    if not os.path.exists(checkpoint_path):
        raise FileNotFoundError(f"Checkpoint does not exist: {checkpoint_path}")
    try:
        from model import GeneratorUNet  
        generator = GeneratorUNet(in_channels, out_channels)
        checkpoint = torch.load(checkpoint_path, map_location=torch.device('cpu'))
        state_dict = checkpoint['generator_state_dict'] if 'generator_state_dict' in checkpoint else checkpoint
        generator.load_state_dict(state_dict)
        generator.eval()
        print("Generator loaded successfully")
        return generator
    except Exception as e:
        raise Exception(f"Error loading generator: {e}")

def create_denoising_demo(epoch=3, checkpoint_path=None):
    print(f"Starting demo for epoch {epoch}")

    base_path = 'intermediate_results/images/qspace_3d'
    paths = {
        'real_A': f'{base_path}/epoch_{epoch}_real_undersampled_A.vox',
        'real_B': f'{base_path}/epoch_{epoch}_real_qspace_B.vox',
        'fake_B': f'{base_path}/epoch_{epoch}_fake_qspace_B.vox'
    }

    real_A = read_vox_file(paths['real_A'])
    real_B = read_vox_file(paths['real_B'])
    
    if checkpoint_path and os.path.exists(paths['fake_B']):
        print("Using pre-generated fake_B from file")
        fake_B = read_vox_file(paths['fake_B'])
    elif checkpoint_path:
        print("Regenerating fake_B using the model")
        generator = load_generator(checkpoint_path)
        with torch.no_grad():
            input_tensor = torch.tensor(real_A, dtype=torch.float32).unsqueeze(0)
            print(f"Input tensor shape: {input_tensor.shape}")
            fake_B = generator(input_tensor).numpy().squeeze(0)
            print(f"Generated fake_B shape: {fake_B.shape}")
    else:
        fake_B = read_vox_file(paths['fake_B'])

    rspace_real_A = qspace_to_rspace(real_A)
    rspace_real_B = qspace_to_rspace(real_B)
    rspace_fake_B = qspace_to_rspace(fake_B)

    print(f"rspace_real_A shape: {rspace_real_A.shape}")
    slice_idx = rspace_real_A.shape[0] // 2
    undersampled_slice = rspace_real_A[slice_idx, :, :]
    ground_truth_slice = rspace_real_B[slice_idx, :, :]
    denoised_slice = rspace_fake_B[slice_idx, :, :]

    print("Generating static comparison plot")
    plt.figure(figsize=(15, 5))
    plt.subplot(1, 3, 1)
    plt.imshow(undersampled_slice, cmap="gray")
    plt.title("Undersampled (Input)")
    plt.axis("off")
    plt.subplot(1, 3, 2)
    plt.imshow(denoised_slice, cmap="gray")
    plt.title("Denoised (Generated)")
    plt.axis("off")
    plt.subplot(1, 3, 3)
    plt.imshow(ground_truth_slice, cmap="gray")
    plt.title("Ground Truth")
    plt.axis("off")
    plt.tight_layout()
    plt.savefig(f"demo_static_epoch_{epoch}.png")
    plt.close()
    print(f"Saved demo_static_epoch_{epoch}.png")

    print("Creating transition GIF")
    frames = []
    num_frames = 20
    target_size = (200, 200)  
    for i in range(num_frames):
        alpha = i / (num_frames - 1)
        intermediate = (1 - alpha) * undersampled_slice + alpha * denoised_slice
        print(f"Frame {i}: min={intermediate.min()}, max={intermediate.max()}, shape={intermediate.shape}")
        
        if intermediate.max() == intermediate.min():
            print(f"Warning: Frame {i} has no contrast (max == min). Setting frame to zeros.")
            frame = np.zeros_like(intermediate, dtype=np.uint8)
        else:
            frame = ((intermediate - intermediate.min()) / (intermediate.max() - intermediate.min()) * 255).astype(np.uint8)
        
        # Resize the frame
        frame_pil = Image.fromarray(frame)
        frame_pil = frame_pil.resize(target_size, Image.Resampling.LANCZOS)
        frame_resized = np.array(frame_pil)
        frames.append(frame_resized)

    try:
        gif_path = f"demo_transition_epoch_{epoch}.gif"
        print(f"Saving GIF to: {os.path.abspath(gif_path)}")
        imageio.mimsave(gif_path, frames, fps=10)
        print(f"Saved {gif_path}")
    except Exception as e:
        print(f"Error saving GIF: {e}")
        exit(1)

if __name__ == "__main__":
    print('Starting demo')
    epoch = 3
    checkpoint_path = 'intermediate_results/save_models_intermediate/checkpoint.pth'
    try:
        create_denoising_demo(epoch, checkpoint_path)
    except Exception as e:
        print(f"Demo failed with error: {e}")
        sys.exit(1)
    print("Demo completed")