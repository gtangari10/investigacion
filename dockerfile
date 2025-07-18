FROM ghcr.io/astral-sh/uv:python3.10-bookworm-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/app/.venv/bin:$PATH"

WORKDIR /app

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
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



COPY pyproject.toml uv.lock /app/

RUN uv sync --locked

COPY . /app

EXPOSE 8888

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--allow-root"]