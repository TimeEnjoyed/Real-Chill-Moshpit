FROM ocaml/opam

WORKDIR /app

COPY . .

# get around permission denied issues when running dune build
RUN sudo chown -R opam:opam *

# install the os dependencies the opam packages need
RUN sudo apt install pkg-config libssl-dev libffi-dev -y

# is there some sort of file that opam can use instead of defining dependencies here?
RUN opam install \
    "dune>=3.9.0" \
    "ocaml>=5.0.0" \
    "ocamlfind>=1.9.6"  \
    "async>=v0.15.0"  \
    "async_ssl>=v0.15.0"  \
    "cohttp>=5.1.0"  \
    "cohttp-async>=5.1.0"  \
    "ppx_let>=v0.15.0" \
    "yojson>=2.1.0" \
    "websocket-async"

RUN cd chatbot && eval $(opam env) && dune build

RUN cd pubsub && eval $(opam env) && dune build