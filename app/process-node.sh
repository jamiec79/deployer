#!/usr/bin/env bash

SIDECHAIN_PATH="/home/$USER/ark-sidechain"
CHAIN_NAME="sidechain"

process_node_args()
{
    while getopts p:n: option; do
        case "$option" in
            p)
                SIDECHAIN_PATH=$OPTARG
            ;;
            n)
                CHAIN_NAME=$OPTARG
            ;;
        esac
    done
}

process_node_start()
{
    heading "Starting..."
    process_node_args
    cd $SIDECHAIN_PATH
    forever start app.js --config "config.$CHAIN_NAME.autoforging.json" --genesis "genesisBlock.$CHAIN_NAME.json"
    success "Start OK!"

    read -p "Watch Logs? [y/N] :" choice
    if [[ "$choice" =~ ^(yes|y) ]]; then
        process_node_logs
    fi
}

process_node_stop()
{
    heading "Stopping..."
    process_node_args
    cd $SIDECHAIN_PATH
    forever stop app.js
    success "Stop OK!"
}

process_node_restart()
{
    heading "Restarting..."
    process_node_stop
    process_node_start
    success "Restart OK!"
}

process_node_logs()
{
    cd $SIDECHAIN_PATH
    tail -fn 500 logs/ark.log
}
