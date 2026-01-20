#!/bin/bash

IS_LOCKED=$(ps -e | grep hyprlock)

if [ -z "$IS_LOCKED" ] 
then
  hyprlock
fi
