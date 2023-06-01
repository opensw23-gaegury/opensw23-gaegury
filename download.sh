#!/bin/bash
#for windows

(
mkdir -p data/pretrained
cd data/pretrained

gdown https://drive.google.com/uc?id=1norNWWGYP3EZ_o05DmoW1ryKuKMmhlCX
gdown https://drive.google.com/uc?id=1QEl-btGbzQz6IwkXiFGd49uQNTUtTHsk
)

# data
(
gdown https://drive.google.com/uc?id=1Q_dxuyI41AAmSv9ti3780BwaJQqwvwMv
unzip data.zip
rm data.zip
)