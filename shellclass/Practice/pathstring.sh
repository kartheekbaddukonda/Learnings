function get_kube_dir () {
    PATHSTRING="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    suffix=/
    PATHSTRING=${PATHSTRING%$suffix}
    suffix=/scripts
    PATHSTRING=${PATHSTRING%$suffix}
    echo ${PATHSTRING}
}

KUBE_DIR=$(get_kube_dir)
echo $KUBE_DIR
