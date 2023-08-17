# DEVNOTE

## Settings
- 실행 : `python main.py --port=PORT --cuda-device=3 --listen=0.0.0.0`
    - `--port` : 포트번호
    - `--cuda-device` : multi-gpu환경에서, gpu 장비 id
    - `--listen` : IP 공개 마스크 / host IP
- model/ : sd-webui와의 model 폴더 공유를 위해 다음과 같이 sym-link 설정
    - `model/checkpoints -> webui/models/Stable-diffusion`
    - `model/loras -> webui/models/Lora`
    - `model/vae -> webui/models/VAE`
    - `model/embeddings -> webui/embeddings`
    - 한번에 처리 : `./link_model.sh /path/to/sd-webui` 실행
- Default Graph 설정
    - `web/scripts/defaultGraph.js` : 처음에 화면에 보여지는 기본 그래프, Js Object형식
    - `web/scripts/ui.js` : 웹으로 보여지는 UI 메인 화면
        - 752번째 줄, load-default 버튼 클릭에 대한 콜백 함수에, 내 그래프 데이터 삽입
        ```js
        $el("button", {
                id: "comfy-load-default-button", textContent: "Load Default", onclick: () => {
                    if (!confirmClear.value || confirm("Load default workflow?")) {
                        const my_sdxl_graph = {'my': "graph"};
                        app.loadGraphData(my_sdxl_graph)
                    }
                }
            }),
        ```

##  Usage
- Loader / CLIPTextEncode / Sampler / Image / Latent 노드들을 중심으로 파이프라인 만들어짐
    - Loader : 모델, ckpt, safetensors(체크포인트, vae, lora 등 ) 등을 로드
    - Latent : 타겟 해상도에 맞는 latent noise 생성
    - CLIPTextEncode : 입력 텍스트를 conditioning(텐서)로 변환
    - Sampler : 위의 체크포인트 모델, latent noise, conditioning 을 입력 받아, 생성된 latent 이미지 출력
    - VAE Decode : Loader가 로드한 vae로 latent image를 pixel space 이미지로 만드는 작업
    - SaveImage : 그래프 상에서 출력된 Image를 보기 위한 노드
- DAG 형태의 워크플로우를 작성하여, 이용하는 방식
    - 그래프 예제 : https://comfyanonymous.github.io/ComfyUI_examples/

## Tips
- 워크플로우는 생성된 이미지에, PngInfo형태로 같이 저장된다.
    - 타인의 comfyUI 이미지를 내 comfyUI에 drag & drop 시, 그 이미지의 워크플로우가 내 환경에 로드된다.
- JSON형태로 여려 워크플로우를 Save/Load할 수 있다.
