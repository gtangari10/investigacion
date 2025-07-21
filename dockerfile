FROM ghcr.io/astral-sh/uv:python3.9-bookworm-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH"

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        curl \
        cmake \
        doxygen \
        graphviz \
        libeigen3-dev \
        libhdf5-dev \
        libtbb-dev \
        libboost-all-dev \
        libopenexr-dev \
        libilmbase-dev \
        pybind11-dev \
        nlohmann-json3-dev \
        libspdlog-dev \
        pkgconf \
        libopenh264-dev \
        libhwloc-dev \
        qtbase5-dev \
        zlib1g-dev \
        patchelf \
        curl \
        git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    curl -L -o /tmp/sw.tgz https://github.com/SCIInstitute/ShapeWorks/releases/download/v6.6.1/ShapeWorks-v6.6.1-linux.tar.gz && \
    mkdir -p /opt/shapeworks && \
    tar -xzf /tmp/sw.tgz --strip-components=1 -C /opt/shapeworks && \
    rm /tmp/sw.tgz


ENV PATH="/opt/shapeworks/bin:${PATH}" \
    PYTHONPATH="/opt/shapeworks/bin:${PYTHONPATH:-}"

WORKDIR /app





COPY pyproject.toml uv.lock /app/

COPY . /app

RUN uv sync

EXPOSE 8888

CMD ["uv", "run", "jupyter", "notebook", "--ip=0.0.0.0", "--port=8888", "--allow-root"]