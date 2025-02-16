FROM debian:11

# 设置工作目录
WORKDIR /root
USER root

# 安装所需的工具和依赖
RUN apt-get update -qq && apt-get install -qqy --no-install-recommends ack 

# 清理缓存数据
RUN sudo apt clean && \
    sudo rm -rf /var/lib/apt/lists/*

# 设置容器启动命令（如果需要）
CMD ["bash"]
