FROM python:3.9.9-slim
ARG TELLIOT_VERSION
RUN useradd -m reporter
RUN apt-get update && apt install -y build-essential
RUN apt-get install -y curl && apt install -y git
RUN export LATEST_TELLIOT_VER=$(curl --silent "https://api.github.com/repos/tellor-io/telliot-feed-examples/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")') \
	&& export FINAL_VER="${TELLIOT_VERSION:=$LATEST_TELLIOT_VER}" \
	&& echo "telliot-feed-examples version: $FINAL_VER" \
	&& cd /opt && git clone --depth 1 --branch $FINAL_VER https://github.com/tellor-io/telliot-feed-examples.git
WORKDIR /opt/telliot-feed-examples
RUN pip install -e . && pip install -r requirements-dev.txt
RUN mkdir /home/reporter/telliot \
	&& chown -R reporter:reporter /opt/telliot-feed-examples \
	&& chown -R reporter:reporter /home/reporter
VOLUME /home/reporter/telliot
USER reporter
ENV HOME /home/reporter
ENTRYPOINT ["python","/opt/telliot-feed-examples/src/telliot_feed_examples/cli.py"]