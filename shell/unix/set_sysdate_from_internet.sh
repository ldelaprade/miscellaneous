#!/bin/sh


ETH_IP=1.1.1.1
GOOGLE="google.com"
START_PAGE="startpage.com"


CHECK_CONNECTION="ping -w 3 -i 1 -c1"

short_format=""

reformat_date()
{
    long_fmt=$1
    YEAR=$(echo "$long_fmt" | awk '{split($0,a," "); print a[3]}')
    MONTH=$(echo "$long_fmt" | awk '{split($0,a," "); print a[2]}')
    DAY=$(echo "$long_fmt" | awk '{split($0,a," "); print a[1]}')
    TIME=$(echo "$long_fmt" | awk '{split($0,a," "); print a[4]}')

    case $MONTH in
        Jan) MON="01" ;;
        Feb) MON="02" ;;
        Mar) MON="03" ;;
        Apr) MON="04" ;;
        May) MON="05" ;;
        Jun) MON="06" ;;
        Jul) MON="07" ;;
        Aug) MON="08" ;;
        Sep) MON="09" ;;
        Oct) MON="10" ;;
        Nov) MON="11" ;;
        Dec) MON="12" ;;
    esac
    short_format=$(printf "%s-%s-%s %s" $YEAR $MON $DAY $TIME)
}

# When set_date_command_status is '0', then date was set successfully
set_date_command_status=1

echo "-----------------"
echo ${ETH_IP}
echo "-----------------"
if ${CHECK_CONNECTION} ${ETH_IP}; then
    datetext=$(curl -I https://${ETH_IP}/ 2>/dev/null | grep "[Dd]ate:" |sed 's/[Dd]ate: [A-Z][a-z][a-z], //g'| sed 's/\r//');
    echo "Date Retrieved = $datetext" ;
    parsedDate=$(echo $datetext | awk '{split($0,a," "); print a[1],a[2],a[3], a[4]}')
    echo "Date parsed = $parsedDate" ;
    reformat_date "$parsedDate"
    echo "Short format (date command compatible) = $short_format" ;

    echo -n "Date set = " ;
    date --set="$short_format"
    set_date_command_status=$?
    [ $set_date_command_status -eq 0 ] && echo "|Set Date OK|" || echo "| !!! Set Date Failed !!! |"
    [ $set_date_command_status -eq 0 ] && exit 0
fi

echo "-----------------"
echo ${GOOGLE}
echo "-----------------"
if ${CHECK_CONNECTION} ${GOOGLE}; then
    datetext=$(curl -v --silent https://${GOOGLE}/ 2>&1| grep "< [Dd]ate:" | sed -e 's/< [Dd]ate: //');
    echo "Date Retrieved = $datetext" ;
    parsedDate=$(echo $datetext | awk '{split($0,a," "); print a[2],a[3],a[4], a[5]}')
    echo "Date parsed = $parsedDate" ;
    reformat_date "$parsedDate"
    echo "Short format (date command compatible) = $short_format" ;

    echo -n "Date set = " ;
    date --set="$short_format"
    set_date_command_status=$?
    [ $set_date_command_status -eq 0 ] && echo "|Set Date OK|" || echo "| !!! Set Date Failed !!! |"
    [ $set_date_command_status -eq 0 ] && exit 0
fi

echo "-----------------"
echo ${START_PAGE}
echo "-----------------"
if ${CHECK_CONNECTION} ${START_PAGE}; then
    datetext=$(curl -I https://${START_PAGE}/ 2>/dev/null | grep -i '^[Dd]ate:' | sed 's/^[Dd]ate: //g');
    echo "Date Retrieved = $datetext" ;
    parsedDate=$(echo $datetext | awk '{split($0,a," "); print a[2],a[3],a[4], a[5]}')
    echo "Date parsed = $parsedDate" ;
    reformat_date "$parsedDate"
    echo "Short format (date command compatible) = $short_format" ;

    echo -n "Date set = " ;
    date --set="$short_format"
    set_date_command_status=$?
    [ $set_date_command_status -eq 0 ] && echo "|Set Date OK|" || echo "| !!! Set Date Failed !!! |"
    [ $set_date_command_status -eq 0 ] && exit 0
fi


exit 1

