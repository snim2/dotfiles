# Who is holding open this port or file??
# From pmarreck @ github

function whoport {
    lsof -P -i ":${1}"
}

function whofile {
    lsof "${1}"
}
