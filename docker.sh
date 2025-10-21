#!/bin/bash

set -e

echo "=== Обновление системы ==="
sudo apt update && sudo apt upgrade -y

echo "=== Установка зависимостей ==="
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

echo "=== Добавление Docker GPG ключа ==="
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /tmp/docker.gpg
sudo mv -f /tmp/docker.gpg /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo "=== Добавление Docker репозитория ==="
echo \
  "deb [arch=$(dpkg --print-architecture) \
  signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

echo "=== Обновление и установка Docker Engine ==="
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "=== Проверка установки Docker ==="
sudo docker version
sudo docker info

echo "=== Добавление пользователя в группу docker ==="
sudo usermod -aG docker $USER
echo "=== Установка завершена. Для применения группы docker — выйди и зайди в систему снова ==="
