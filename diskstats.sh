#!/bin/bash
color_start="\033[34m"
color_end="\033[0m"

language="en"
dev=""
output_mode="key_value"
word="all"
# check=""
function init() {
    test -f /proc/diskstats || {
        echo "ERROR: /proc/diskstats not found"
        exit 1
    }
    eval set -- "$(getopt -o "d:,v,h,c,z,e,s" -l "en,zh,dev:,value,help,seq,tsr,tsw,ioc,iot,iowt,check,ars,aws" -n "$0" -- "$@")"
    while true; do
        case "$1" in
        -e | --en)
            language="en"
            shift 1
            ;;
        -z | --zh)
            language="zh"
            shift 1
            ;;
        -d | --dev)
            dev=$2
            shift 2
            ;;
        -v | --value)
            output_mode="value"
            shift 1
            ;;
        -h | --help)
            echo "Usage: diskstats.sh [OPTION]..."
            echo "Display disk I/O statistics"
            echo ""
            echo "  -e, --en              output in English"
            echo "  -z, --zh              output in Chinese"
            echo "  -d, --dev             specify device name"
            echo "  -v, --value           output in value mode"
            echo "  -h, --help            display this help and exit"
            echo "  -s, --seq             output in sequence mode"
            # echo "  -c, --check           check the disk I/O statistics"
            echo "      --tsr             output time spent reading(ms)"
            echo "      --tsw             output time spent writing(ms)"
            echo "      --ioc             output I/Os currently in progress"
            echo "      --iot             output time spent doing I/Os"
            echo "      --iowt            output weighted time spent doing I/Os"
            echo "      --ars             output average read sector"
            echo "      --aws             output average write sector"
            exit 0


            ;;
        -s | --seq)
            seq="enable"
            shift 1
            ;;
        # -c | --check)
        #     check="enable"
        #     shift 1
        #     ;;
        --tsr)
            test "$word" == "all" && word=""
            word=$word"_tsr_"
            shift 1
            ;;
        --tsw)
            test "$word" == "all" && word=""
            word=$word"_tsw_"
            shift 1
            ;;
        --ioc)
            test "$word" == "all" && word=""
            word=$word"_ioc_"
            shift 1
            ;;
        --iot)
            test "$word" == "all" && word=""
            word=$word"_iot_"
            shift 1
            ;;
        --iowt)
            test "$word" == "all" && word=""
            word=$word"_iowt_"
            shift 1
            ;;
        --ars)
            test "$word" == "all" && word=""
            word=$word"_ars_"
            shift 1
            ;;
        --aws)
            test "$word" == "all" && word=""
            word=$word"_aws_"
            shift 1
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            exit 1
            ;;
        esac
    done
}

function major_number() {
    test "$seq" == "enable" && num_seq="1 "
    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}major number${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}主设备号${color_end}:"
    fi
}
function minor_number() {
    test "$seq" == "enable" && num_seq="2 "
    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}minor number${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}次设备号${color_end}:"
    fi
}
function device_name() {
    test "$seq" == "enable" && num_seq="3 "
    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}device name${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}设备名${color_end}:"
    fi
}
function reads_completed_successfully() {
    test "$seq" == "enable" && num_seq="4 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}reads completed successfully${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}读完成次数${color_end}:"
    fi
}
function reads_merged() {
    test "$seq" == "enable" && num_seq="5 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}reads merged${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}合并读次数${color_end}:"
    fi
}
function sectors_read() {
    test "$seq" == "enable" && num_seq="6 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}sectors read${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}读扇区数${color_end}:"
    fi
}
function time_spent_reading() {
    test "$seq" == "enable" && num_seq="7 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}time spent reading(ms)${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}读花费时间(ms)${color_end}:"
    fi
}
function writes_completed() {
    test "$seq" == "enable" && num_seq="8 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}writes completed${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}写完成次数${color_end}:"
    fi
}
function writes_merged() {
    test "$seq" == "enable" && num_seq="9 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}writes merged${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}合并写次数${color_end}:"
    fi

}
function sectors_written() {
    test "$seq" == "enable" && num_seq="10 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}sectors written${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}写扇区数${color_end}:"
    fi
}
function time_spent_writing() {
    test "$seq" == "enable" && num_seq="11 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}time spent writing(ms)${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}写花费时间(ms)${color_end}:"
    fi
}
function I/Os_currently_in_progress() {
    test "$seq" == "enable" && num_seq="12 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}I/Os currently in progress${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}I/Os当前进行次数${color_end}:"
    fi
}
function time_spent_doing_I/Os() {
    test "$seq" == "enable" && num_seq="13 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}time spent doing I/Os(ms)${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}花费时间进行I/Os(ms)${color_end}:"
    fi
}
function weighted_time_spent_doing_I/Os() {
    test "$seq" == "enable" && num_seq="14 "

    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}weighted time spent doing I/Os(ms)${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}加权花费时间进行I/Os(ms)${color_end}:"
    fi
}
function avg_read_sector(){
    test "$seq" == "enable" && num_seq="15 "
    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}average read sector(ms)${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}平均读扇区(ms)${color_end}:"
    fi

}
function avg_write_sector(){
    test "$seq" == "enable" && num_seq="16 "
    if [ "$1" == "en" ]; then
        echo -e -n "${color_start}${num_seq}average write sector(ms)${color_end}:"
    else
        echo -e -n "${color_start}${num_seq}平均写扇区(ms)${color_end}:"
    fi

}
function collect() {
    awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14}' /proc/diskstats | while read -r man min dn rcs rm sr tsr wc wm sw tsw iocp tsdio wtsdio; do
        # if [ "$check" == "enable" ]; then

        #     exit 0
        # fi 
        if [ -z "$dev" ] || [ "$dev" == "$dn" ]; then

            if [ "$word" == "all" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${man}"
                else
                    echo -e "$(major_number "$1") ${man}"
                fi
            fi

            if [ "$word" == "all" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${min}"
                else
                    echo -e "$(minor_number "$1") ${min}"
                fi
            fi

            if [ "$word" == "all" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${dn}"
                else
                    echo -e "$(device_name "$1") ${dn}"
                fi
            fi

            if [ "$word" == "all" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${rcs}"
                else
                    echo -e "$(reads_completed_successfully "$1") ${rcs}"
                fi
            fi

            if [ "$word" == "all" ]; then

                if [ "$output_mode" == "value" ]; then
                    echo "${rm}"
                else
                    echo -e "$(reads_merged "$1") ${rm}"
                fi
            fi

            if [ "$word" == "all" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${sr}"
                else
                    echo -e "$(sectors_read "$1") ${sr}"
                fi
            fi

            if [ "$word" == "all" ] || [ "$word" == "_tsr_" ]; then

                if [ "$output_mode" == "value" ]; then
                    echo "${tsr}"
                else
                    echo -e "$(time_spent_reading "$1") ${tsr}"
                fi
            fi

            if [ "$word" == "all" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${wc}"
                else
                    echo -e "$(writes_completed "$1") ${wc}"
                fi
            fi

            if [ "$word" == "all" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${wm}"
                else
                    echo -e "$(writes_merged "$1") ${wm}"
                fi
            fi

            if [ "$word" == "all" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${sw}"
                else
                    echo -e "$(sectors_written "$1") ${sw}"
                fi
            fi

            if [ "$word" == "all" ] || [ "$word" == "_tsw_" ]; then
                if [ "$output_mode" == "value" ] ; then
                    echo "${tsw}"
                else
                    echo -e "$(time_spent_writing "$1") ${tsw}"
                fi
            fi

            if [ "$word" == "all" ] || [ "$word" == "_ioc_" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${iocp}"
                else
                    echo -e "$(I/Os_currently_in_progress "$1") ${iocp}"
                fi
            fi

            if [ "$word" == "all" ] || [ "$word" == "_iot_" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${tsdio}"
                else
                    echo -e "$(time_spent_doing_I/Os "$1") ${tsdio}"
                fi
            fi

            if [ "$word" == "all" ] || [ "$word" == "_iowt_" ]; then
                if [ "$output_mode" == "value" ]; then
                    echo "${wtsdio}"
                else
                    echo -e "$(weighted_time_spent_doing_I/Os "$1") ${wtsdio}"
                fi
            fi
            if [ "$word" == "all" ] || [ "$word" == "_ars_" ] ; then
                local ret
                ret=$(calc_float "$tsr" "$sr")
                if [ "$output_mode" == "value" ]; then
                    echo "${ret}"
                else
                    echo -e "$(avg_read_sector "$1") ${ret}"
                fi
            fi
            if [ "$word" == "all" ] || [ "$word" == "_aws_" ] ; then
                local ret
                ret=$(calc_float "$tsw" "$sw")
                if [ "$output_mode" == "value" ]; then
                    echo "${ret}"
                else
                    echo -e "$(avg_write_sector "$1") ${ret}"
                fi
            fi
            continue
        fi

    done
}
function calc_float(){
    test "$1" == "0" && echo "0" && return
    test "$2" == "0" && echo "0" && return
    c=$(echo "scale=5; ${1} / ${2}" | bc)
    if [[ $c == .* ]]; then
        c="0${c}"
    fi
    echo "$c"
}
init "$@"
collect "$language"
