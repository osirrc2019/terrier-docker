FROM openjdk:8-alpine

COPY init init
COPY index index
COPY search search
RUN ["chmod", "+x", "/index"] 
RUN ["chmod", "+x", "/init"] 
RUN ["chmod", "+x", "/search"] 

RUN apk add python3
RUN apk add git
RUN apk add maven
WORKDIR /work
