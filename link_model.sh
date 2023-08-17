printf "Link ComfyUI model directories to sd-webui...\n" &&\
cd ./models &&\
rm -r checkpoints loras vae vae_approx embeddings &&\
ln -s ${1}/models/Stable-diffusion checkpoints &&\
ln -s ${1}/models/Lora loras &&\
ln -s ${1}/models/VAE vae &&\
ln -s ${1}/models/VAE-approx vae_approx &&\
ln -s ${1}/embeddings embeddings &&\
printf "Done!\n"
