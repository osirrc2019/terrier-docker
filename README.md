# OSIRRC Docker Image for Terrier

[![Build Status](https://travis-ci.com/osirrc/terrier-docker.svg?branch=master)](https://travis-ci.com/osirrc/terrier-docker)
[![Docker Cloud Build Status](https://img.shields.io/docker/cloud/build/osirrc2019/terrier.svg)](https://hub.docker.com/r/osirrc2019/terrier)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3245210.svg)](https://doi.org/10.5281/zenodo.3245210)

[**Arthur Câmara**](https://github.com/ArthurCamara) and [**Craig Macdonald**](https://github.com/cmacdonald)

This is the docker image for the [Terrier](http://terrier.org/) toolkit (v5.2) conforming to the [OSIRRC jig](https://github.com/osirrc/jig/) for the [Open-Source IR Replicability Challenge (OSIRRC) at SIGIR 2019](https://osirrc.github.io/osirrc2019/).
This image is available on [Docker Hub](https://hub.docker.com/r/osirrc2019/terrier)

+ Supported test collections: `robust04`, `gov2`, `cw09b`, `cw12b` (web), `core18` (newswire)
+ Supported hooks: `init`, `index`, `train`, `search`
+ Check the most current release version at the [Releases](https://github.com/osirrc/terrier-docker/releases) page, and replace `vx.y.z` with the desired release version or with `current` for the latest release

## Quick Start

The following `jig` command can be used to index TREC disks 4/5 for `robust04`:

```
python run.py prepare --repo osirrc2019/terrier --tag vx.y.z --collections robust04=/tmp/disk45/=trectext
```

The following `jig` command can be used to perform a retrieval run on the collection with the `robust04` test collection, using BM25 as ranker:

```bash
python run.py search  \
    --repo osirrc2019/terrier \
    --tag vx.y.z \
    --collection robust04 \
    --topic topics/topics.robust04.txt \
    --qrels qrels/qrels.robust04.txt\
    --output /tmp/runs
```


## Retrieval Methods:

This image supports the following weighting models: BM25 (`bm25`), PL2 (`pl2`) and `DPH` (`dph`). 

Additionally, it supports Query Expansion and Proximity-based (DFRD) search, by including `qe`, `prox` or `prox_qe` to the `--opts config` argument: `--opts config=<retrieval_model>_<extra>`:

(BM25)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=bm25
```

(BM25 + query expansion)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=bm25_qe
```

(BM25 + Proximity)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=bm25_prox
```

(BM25 + Proximity + query expansion)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=bm25_prox_qe
```

(PL2)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=pl2
```

(PL2 + query expansion)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=pl2_qe
```

(PL2 + Proximity)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=pl2_prox
```
(PL2 + Proximity + query expansion)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=pl2_prox_qe
```

(DPH)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=dph
```	

(DPH + query expansion)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=dph_qe
```

(DPH + Proximity)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=dph_prox
```	

(DPH + Proximity + query expansion)

```bash
python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=dph_prox_qe
```

**NOTE:** for running DFRD (Proximity-based model), the index must be build using the `--opts=block.indexing=true` param


## Learning to Rank Runs

Learning-to-rank will typically require that the index has more information, e.g. fields or blocks.

### Indexing:

```bash
python run.py prepare     --repo osirrc2019/terrier --tag vx.y.z   --collections robust04=/tmp/disk45/=trectext --opts "FieldTags.process=HEADLINE"
```

### Training:

You need to specify the features to be used by Terrier - see <http://terrier.org/docs/v5.1/learning.html> for more information about Terrier feature definitions.

```bash
python run.py train  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt    --test_split $PWD/sample_training_validation_query_ids/robust04_test.txt  --validation_split $PWD/sample_training_validation_query_ids/robust04_validation.txt --model_folder /tmp/runs --opts features="SAMPLE;WMODEL:SingleFieldModel(BM25,0);QI:SingleFieldModel(Dl,0)"
```

### Retrieval:

You will need to specify the `bm25_ltr_jforest` configuration.

	python run.py search  --repo osirrc2019/terrier --tag vx.y.z --collection robust04  --topic topics/topics.robust04.txt --qrels qrels/qrels.robust04.txt   --output /tmp/runs --opts config=bm25_ltr_jforest

## Expected Results

### robust04

MAP                                     | BM25      | +QE       | +Prox     | +Prox + QE| DPH | + QE | +Prox | +Prox +QE |  PL2       | +QE       |
:---------------------------------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
[TREC 2004 Robust Track Topics](http://trec.nist.gov/data/robust/04.testset.gz)| 0.2363 |  0.2762 | 0.2404 | 0.2781  |0.2479|0.2821| 0.2501| 0.2869| 0.2241 | 0.2538

### core18

MAP                                     | BM25      | +QE   | +Prox     | +Prox + QE| DPH | + QE | +Prox | +Prox +QE | PL2   | +QE   
:---------------------------------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
[TREC 2018 Common Core Track Topics](https://trec.nist.gov/data/core/topics2018.txt) |0.2326|0.2975|0.2369|0.2960|0.2427|0.3055|0.2428|0.3035 |0.2225| 0.2787

### GOV2

MAP                                     | BM25      | +QE   | +Prox     | +Prox + QE| DPH | + QE | +Prox | +Prox +QE | PL2   | +QE   
:---------------------------------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|
[TREC 2004 Terabyte Track: Topics 701-750](http://trec.nist.gov/data/terabyte04.html) |0.2461|0.2621|0.2537|0.2715|0.2804|0.3120|0.2834|0.3064|0.2334|0.2478
[TREC 2005 Terabyte Track: Topics 751-800](http://trec.nist.gov/data/terabyte05.html) |0.3081|0.3506|0.3126| 0.3507|0.3311|0.3754|0.3255|0.3095|0.2884|0.3160
[TREC 2006 Terabyte Track: Topics 801-850](http://trec.nist.gov/data/terabyte06.html) |0.2629|0.3118|0.2724|0.3085|0.2917|0.3494|0.2904|0.3288|0.2363|0.2739

## Interact hooks

This image also supports the `interact` hooks from the [OSIRRC JIG](https://github.com/osirrc/jig). After initializing the image (with `python run.py prepare`):
```
python run.py interact --repo terrier --tag vx.y.z
```
The following (internal) ports will be made available:

+ Port `1980`: _Search interface_:  A user-friendly HTML search interface, reachable using a web browser. (more information can be found at the [Terrier Documentation](http://terrier.org/docs/v5.1/terrier_http.html))

+ Port `1981`:  _REST API_: This port provides a REST API for Terrier. You can either directly submit requests to this port or use another Terrier instance as a client, like:

```bash
$ /bin/terrier interactive -I http://dockerhost:1981/
terrier query> information retrieval end:5
  Displaying 1-6 results
0 FBIS4-20699 10.268754805435458
1 FBIS4-20702 9.768490153503198
2 FR941027-2-00046 9.491347902606723
3 FBIS4-20701 9.456022500508775
4 FBIS3-24510 9.31403481019499
5 FBIS4-20700 8.79234249484928
```

+ Port `1982`: _Terrier-Spark Jupyter Notebook_: This port initialises a Scala Jupyter Notebook that is able to interact with the Terrier Index previously initialized. By acessing the notebook, a sample notebook (`simpleRun.ipynb`) is available, with minimal working examples. For more information, check [Macdonald, 2018](http://eprints.gla.ac.uk/160904/7/160904.pdf) and [Macdonald et al.,  2018](http://ceur-ws.org/Vol-2167/paper12.pdf).
  
**NOTE** Currently, the JIG may redirect these ports to diverse ones in the host machine. This is due to the way that Docker deals with port assignment. Therefore, you should check the correct port assignment by running:

```bash
$> docker ps
```

and check the right port assignment under the `PORTS` column.

## Reviews

+ Documentation reviewed at commit [`0b13139`](https://github.com/osirrc/terrier-docker/commit/c09730fab75e9c4ff892cb9dc5d6b7a500b13139) (2019-06-16) by [Ryan Clancy](https://github.com/r-clancy/).
+ Documentation reviewed at commit [`9700a36`](https://github.com/osirrc/terrier-docker/commit/c00dcefc4dc19aae25426013a65bb04b79700a36) (2019-06-21) by [Ryan Clancy](https://github.com/r-clancy/).
