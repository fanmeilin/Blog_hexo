#!/bin/bash
git pull
git submodule update --init --recursive
git add -A
git commit -m save
git push
hexo clean
hexo g
hexo d

