# will error if file is empty (no config) or if sources is undefined or empty array.
cat "$SRC_CONFIG" | grep -vE '^$' >/dev/null && \
. $SRC_CONFIG && [ "${#SOURCES[@]}" -gt "0" ]
