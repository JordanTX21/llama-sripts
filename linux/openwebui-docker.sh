docker run -d \
  -p 0.0.0.0:3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -e OPENAI_API_BASE_URL="http://host.docker.internal:8080/v1" \
  -e OPENAI_API_KEY="not-needed" \
  -e ENABLE_OLLAMA_API=false \
  -e HF_TOKEN="TU_TOKEN_DE_HUGGING_FACE_AQUI" \
  -v open-webui:/app/backend/data \
  --name open-webui \
  --restart always \
  ghcr.io/open-webui/open-webui:main