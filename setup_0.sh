#!/bin/bash

cd workspace

export HOME=/workspace
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH

apt-get update && apt-get install -y git git-lfs curl wget build-essential zlib1g-dev libncurses5-dev libgdbm-dev libbz2-dev libnss3-dev libsqlite3-dev libssl-dev liblzma-dev libreadline-dev libffi-dev libgl1-mesa-dev locales fish vim nano iputils-ping net-tools software-properties-common fonts-powerline

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
echo 'eval "$(pyenv init --path)"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
pyenv install 3.11.6
pyenv install 3.10.10
pyenv global 3.11.6

git clone https://github.com/YukiTomita-CC/japanese-mistral-300m-recipe.git
cd japanese-mistral-300m-recipe

pip install wandb
wandb login
export WANDB_PROJECT=aku_000

pip install huggingface_hub
huggingface-cli download YukiTomita-CC/temp train.txt.aa --local-dir ./pretrain/dataset --local-dir-use-symlinks False
huggingface-cli download YukiTomita-CC/temp train.txt.ab --local-dir ./pretrain/dataset --local-dir-use-symlinks False
huggingface-cli download YukiTomita-CC/temp test.txt --local-dir ./pretrain/dataset --local-dir-use-symlinks False
cat ./pretrain/dataset/train.txt.aa ./pretrain/dataset/train.txt.ab > ./pretrain/dataset/train.txt
rm ./pretrain/dataset/train.txt.aa ./pretrain/dataset/train.txt.ab

mkdir ./pretrain/tokenizer/spm_tokenizer_neologdn_bytefallback_nofast
huggingface-cli download YukiTomita-CC/temp special_tokens_map.json --local-dir ./pretrain/tokenizer/spm_tokenizer_neologdn_bytefallback_nofast --local-dir-use-symlinks False
huggingface-cli download YukiTomita-CC/temp spiece.model --local-dir ./pretrain/tokenizer/spm_tokenizer_neologdn_bytefallback_nofast --local-dir-use-symlinks False
huggingface-cli download YukiTomita-CC/temp tokenizer_config.json --local-dir ./pretrain/tokenizer/spm_tokenizer_neologdn_bytefallback_nofast --local-dir-use-symlinks False

bash run_all.sh
