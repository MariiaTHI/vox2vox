# vox2vox
3D Volume-to-Volume Generative Adversarial Network for MRI Diffusion Denoising
We developed a 3D volume-to-volume Generative Adversarial Network (GAN) for denoising q-space diffusion MRI. Our base model, Vox2Vox, is sourced from this GitHub repository and is based on the paper by M. Cirillo, D. Abramian, and A. Eklund (arXiv:2003.13653).

Project Overview:
This student project focuses on denoising and reconstructing 3D medical images by converting undersampled q-space images into fully sampled counterparts. Using a 3D GAN with a U-Net generator and a PatchGAN discriminator, our model aims to produce realistic outputs from undersampled 3D MR images. These reconstructed q-space images are then converted into r-space via Fourier transform.

Performance Evaluation:
The model's effectiveness is assessed using Mean Squared Error (MSE) and Structural Similarity Index Measure (SSIM) metrics, demonstrating promising results in enhancing image quality.

