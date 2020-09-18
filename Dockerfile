# 构建可执行二进制文件
# 指定构建的基础镜像
FROM golang:alpine AS builder
# 修改源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 安装相关环境依赖
RUN apk update && apk add --no-cache git bash wget curl
# 运行工作目录
WORKDIR /go/src/v2ray.com/core
# 克隆源码运行安装
RUN git clone --progress https://github.com/v2fly/v2ray-core.git . && \
    bash ./release/user-package.sh nosource noconf codename=$(git describe --tags) buildname=docker-fly abpathtgz=/tmp/v2ray.tgz

# 构建基础镜像
# 指定创建的基础镜像
FROM alpine:latest
# 作者描述信息
MAINTAINER anyone
# 语言设置
ENV LANG zh_CN.UTF-8
# 时区设置
ENV TZ=Asia/Shanghai
# 修改源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 更新源
RUN apk update
# 同步时间
RUN apk add -U tzdata \
&& ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
&& echo ${TZ} > /etc/timezone
# v2ray配置文件
ENV CONFIG=https://raw.githubusercontent.com/ly19811105/v2ray-kintohub/master/config.json
# 拷贝v2ray二进制文件至临时目录
COPY --from=builder /tmp/v2ray.tgz /tmp

# 授予文件权限
RUN set -ex && \
    apk --no-cache add tor ca-certificates && \
    mkdir -p /usr/bin/v2ray && \
    tar xvfz /tmp/v2ray.tgz -C /usr/bin/v2ray && \
    rm -rf /tmp/v2ray.tgz /usr/bin/v2ray/*.sig /usr/bin/v2ray/doc /usr/bin/v2ray/*.json /usr/bin/v2ray/*.dat /usr/bin/v2ray/sys* && \
    chmod +x /usr/bin/v2ray/v2ctl && \
    chmod +x /usr/bin/v2ray/v2ray

# 设置环境变量
ENV PATH /usr/bin/v2ray:$PATH

# 运行v2ray
CMD v2ray -config $CONFIG
