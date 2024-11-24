ver_pure=$(grep 'set(SoftFever_VERSION' version.inc | cut -d '"' -f2)
if [[ "${{ github.event_name }}" == "pull_request" ]]; then
    ver="PR-${{ github.event.number }}"
else
    ver=V$ver_pure
fi
echo "ver=$ver" >> $GITHUB_ENV
echo "ver_pure=$ver_pure" >> $GITHUB_ENV
echo "date=$(date +'%Y%m%d')" >> $GITHUB_ENV
