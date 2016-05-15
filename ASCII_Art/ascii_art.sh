#! /bin/bash


function ui {
    #echo -n "Letter Width: "
    read LETTER_WIDTH

    #echo -n "Letter Height: "
    read LETTER_HEIGHT

    #echo -n "Your message to the world: "
    read MESSSAGE

    #echo "Please Enter the Letters template:"
    import_letters $LETTER_WIDTH $LETTER_HEIGHT
}

function import_letters {
    IFS=''

    CUR_ROW=0
    LETTERS_BULK=""
    while [ $CUR_ROW -lt $LETTER_HEIGHT ] 
    do
        read -r line
        LETTERS_BULK="${LETTERS_BULK}${line}"
        CUR_ROW=$(($CUR_ROW + 1))
    done
    unset IFS
}

function echo_letter {
    # syntax: echo_letter <letter to print> <row/slice number>

    _letter=$1
    _row=$2
    LC_CTYPE=C _ascii=$( printf '%d' "'$_letter")
    
    if [[ ( $_ascii -lt 97 || $_ascii -gt 122 ) ]]  
    then
        _ascii=123 #return a questionmark
    elif [ "$_letter" == ' ' ]
    then
        # just dump spaces for this width and continue
        printf "%0.s " $(eval echo "{1..$LETTER_WIDTH}")
        return
    fi
    
    _offset=$((($_ascii - 97) * $LETTER_WIDTH + ($_row * $LETTER_WIDTH * 27) ))
    echo -n "${LETTERS_BULK:$_offset:$LETTER_WIDTH}"
}

function show_banner {
    # Make sure message is all lower_case
    _my_message=$(to_lower "$MESSSAGE")
    _message_len=${#_my_message}
    for row_num in $(eval echo "{0..$(( $LETTER_HEIGHT - 1))}")
    do
        for char_location in $( eval echo "{0..$(( $_message_len - 1 ))}")
        do
            echo_letter "${_my_message:$char_location:1}" $row_num
        done
        # slice finished. now add a newline
        echo
    done            
} 

function to_lower {
    echo $(echo $1 | tr '[:upper:]' '[:lower:]')
}

#main
ui
show_banner
