from dotenv import load_dotenv
import os
import requests
from openai import OpenAI


load_dotenv()

base_url = os.getenv("BASE_URL")

r = requests.get(f"{base_url}/health")
print("1-check health")
print(r.status_code)
print(r.json())

r = requests.get(f"{base_url}/v1/models")
print("2-check models")
print(r.status_code)
print(r.json())

print("3-check chat completion")
payload = {
    "model": "Qwen/Qwen2.5-0.5B-Instruct",
    "messages": [
        {
            "role": "user",
            "content": "Say hello in one word."
        }
    ],
    "max_tokens": 16
}

r = requests.post(
    f"{base_url}/v1/chat/completions",
    json=payload
)

print("Status:", r.status_code)
print(r.json())


print("4-check chat completion with OpenAI client")

client = OpenAI(
    base_url=f"{base_url}/v1",
    api_key="dummy"
)

resp = client.chat.completions.create(
    model="Qwen/Qwen2.5-0.5B-Instruct",
    messages=[
        {
            "role": "system",
            "content": "You are a terse assistant."
        },
        {
            "role": "user",
            "content": "Name three primary colours."
        }
    ],
    max_tokens=64
)

print("Reply:", resp.choices[0].message.content)
print("Finish reason:", resp.choices[0].finish_reason)
print("Usage:", resp.usage)