#!/bin/bash

export $(sudo cat /src/kaibosh/.env | xargs)
/src/kaibosh/latest/bin/kaibosh eval "Kaibosh.Release.migrate"
