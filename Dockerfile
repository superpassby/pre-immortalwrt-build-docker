FROM debian:11

# 设置工作目录
WORKDIR /root
USER root

# 安装所需的工具和依赖
RUN apt-get update -qq && apt-get install -qqy --no-install-recommends ack 

# 设置容器启动命令（如果需要）
CMD ["bash"]
