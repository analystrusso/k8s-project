#!/bin/bash
#starts up minikube and the synergychat application
minikube start --extra-config "apiserver.cors-allowed-origins=["http://boot.dev"]"

#starts up the minikube dashboard
minikube dashboard --port=63840

#sets up secure tunnel
minikube tunnel --bind-address="127.0.0.1" -c


