#! /usr/bin/bash


herbstclient set frame_gap $(( $( herbstclient get frame_gap ) + $1 ))
