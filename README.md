# opensw23-gaegury  
## 팀소개  
### 멤버구성  
- 천송현 201911219 조장  
- 이승민 202013002 발표자    
- 최해원 202011906 코더  
- 조용찬 202011374 코더  


## Topic Introduction  
---
### About Image Inpainting
> Image inpainting은 디지털 이미지 처리 기술의 일종으로, 손상된 이미지 영역을 다시그리거나 삭제된 부분을 채워준다. 하지만 이 방법에는 문제점들이 있는데, 먼저 특정 마스크 분포에 대해 학습하므로, 마스크 패턴에 대해 일반화하는데 어려움을 겪어 새로운 마스크 패턴에 대해서는 적절하지 않은 결과를 초래한다. 또, 사람의 얼굴 영역을 복구하는 경우에도 눈, 코, 입 등의 위치가 일관되지 않거나, 배경과 부자연스럽게 블렌딩되는 문제가 발생하는 등 의미론적인 일관성을 유지하는 데 어려움을 겪기도 한다. 이미지의 빠진 영역을 채우는 Image inpainting은 자연스러움이 중요시 되는 만큼, 그 방법들이 다양한 종류의 mask를 다루거나 빈 곳을 채울 수 있어야 한다. 기존의 GAN기반 혹은 autoregressive 모델들은 mask의 분포에 대해서 학습을 진행해 그 다양한 종류에 대한 일반화가 거의 충족되지 않았다. 그러나 Repaint는 unconditional하게 학습된 기존 DDPM(Denoising, Diffusion Probabilistic Models)만을 활용하여 특정 mask에 의존하는 학습 없이도 다양하고 품질이 좋은 이미지를 생성해낸다.  

### About Repaint
Repaint는 inpainting mask 자체를 학습하지 않아 2가지 이점을 갖는다.  

> 1. 신경망이 어떠한 mask에 대해서도 일반화가 가능하다.
> 2. 강력한 DDPM 이미지 합성 prior가 있으므로 더 의미론적인 생성을 학습할 수 있게 한다.

  표준 DDPM 샘플링 방법이 종종 의미상 올바르지 않은 이미지를 생성하는 것을 보완하기 위해 resampling에 개선된 denoising 전략이 도입됐다.  
  비록 diffusion process가 느려지는 단점이 있지만, forward와 backward를 동시에 진행하여 의미론적으로 맞는 이미지를 생성할 수 있게 된다.  
  해당 프로젝트에서 사용하는 celeba256_2500000.pt 모델은 다양한 유명인의 얼굴들을 학습하여 인물의 얼굴을 repaint 할 때 사용된다.  
  
## Results  
---  
- Test case  
input image on Building : 2  
input image on face : 1 -> failed to get good results  (sample had good mask matches the mask image but our data didn't match the mask image)  
![KakaoTalk_20230608_162142445](https://github.com/opensw23-gaegury/opensw23-gaegury/assets/90510391/0b769ed1-2904-4902-8baf-3beb1ef718f5)



## Analysis/Visualization    
---  
> Repaint 는 기존에 인물, 건물, 동물들에 대한 학습 데이터를 바탕으로 훼손된 이미지 또는 가려진 이미지를 새로 그려줍니다. 이를 위해서는 이미지를 가리고있는 형태(mask)에 대한 이미지가 필요합니다.  
>> 1. mask에 대한 부분을 기존 이미지에서 지운 이후  
>> 2. 기존에 학습된 데이터를 바탕으로 이미지에 대한 resampling 을 여러번 진행합니다.
>>> 2-1. 최초 실행 시에는 기초를 잡고, 이를 바탕으로 정해진 n번 만큼 resampling 을 합니다.
>>> 2-2. resampling 과정중에는 Gaussian noise 제거를 t_T 번 실행합니다.
>> 3. 이런 과정을 반복하여 이미지를 다시 그려줍니다.  
> 결과물은 resampling 10회 이상에서 유의미한 결과를 나온다고 말하지만, 기존 sample data 에서 5번의 resampling 과정을 통해서도 유의미한 결과를 만들어 낸 것을 확인할 수 있었습니다. 또한, 다음의 조건들을 만족할 수록 결과물이 더 잘 나온 것을 확인할 수 있었습니다.  
> **1) mask 형태에 대한 이미지가 얼마나 기존 이미지의 mask와 정확한 경우**  
> **2) 기존 이미지에 색변화가 많지 않은 경우**  


## Installation  
---
- 설치 방법
```c
  git clone https://github.com/opensw23-gaegury/opensw23-gaegury
```
```c
  pip install numpy torch blobfile tqdm pyYaml pillow     
```
```c
  pip install --upgrade gdown && bash ./download.sh  
  다운로드 안될 시
  https://drive.google.com/uc?id=1norNWWGYP3EZ_o05DmoW1ryKuKMmhlCX  다운로드 후  
  data/pretrained/<다운로드한 pt파일> 위치시키고
  
  https://drive.google.com/uc?id=1Q_dxuyI41AAmSv9ti3780BwaJQqwvwMv 다운로드 후 zip 파일 압축해체한것을  
  datasets 폴더를 아래와 같이 위치시켜야함  
  data/datasets
```

- 실행 방법   
```c
  python test.py --conf_path confs/face_example.yml  
```

- 실행 팁
> confs/face_example.yml 내부에 t_T 값을 낮추고, jump_n_sample 값을 낮추는 것으로 실행 속도를 올릴 수 있음  
> 
- Apply another exmample

```c
      ./confs/face_example.yml 파일에서 

      gt_path: ./data/datasets/gts/face  //gts폴더에 example 들어간 폴더 생성 후 face폴더 대신 해당 폴더명 작성 
      mask_path: ./data/datasets/gt_keep_masks/face   //example에 대응하는 폴더를 gt_keep_masks에서 찾아서 face폴더 대신 작성
```

- to get more pretrained model  
```c
https://openaipublic.blob.core.windows.net/diffusion/jul-2021/256x256_classifier.pt # Trained by OpenAI  
https://openaipublic.blob.core.windows.net/diffusion/jul-2021/256x256_diffusion.pt # Trained by OpenAI  
```

## Presentation  
---  
- this is presentation video link  


## References  
---
https://github.com/andreas128/RePaint  
