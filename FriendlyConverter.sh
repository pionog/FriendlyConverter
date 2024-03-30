# Author : Piotr Noga
# Created On : 08.05.2022
# Last Modified By : Piotr Noga
# Last Modified On : 11.05.2022
# Version : 1.0.2
#
# Description : Prosty program do konwertowania plikow audio, wideo i graficznych.
#               Przyjazny interfejs umozliwia sprawne przejscie przez proces konwertowania pliku nawet dla niedoswiadczonego uzytkownika komputera.
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)

function main() {
zenity --info --title "Witamy" --text "Witamy w programie FriendlyConverter" --height 50 --width 300
Temp=3
Lista=3
MenuFormatowVideo=(".mp4" ".avi" ".flv" ".webm" ".mov" ".m4v")
MenuFormatowAudio=(".mp3" ".wav" ".flac")
MenuFormatowGraficznych=(".jpeg" ".png" ".gif" ".bmp" ".tga" ".tiff")
Obrot=0
CzarB=0
PredA=0
PredV=0
Odwr=0
Echo=0
Tmpo=0
OObrot=0
OCzarB=0
Rozm=0
MenuOpcjiAudio=("Odwr" "Echo" "Tmpo")
Zaznaczone="■"
ESV1="1. Obrot wideo do gory nogami"
    ESV1Z=FALSE
ESV2="2. Film czarno-bialy"
    ESV2Z=FALSE
ESV3="3. Zmiana szybkosci filmu"
    ESV3Z=FALSE
MenuEfektowSpecjalnychVideo=("$ESV1" "$ESV2" "$ESV3")
ESA1="Odwrocenie audio"
    ESA1Z=FALSE
ESA2="Dodanie efektu echo"
    ESA2Z=FALSE
ESA3="Zmiana tempa"
    ESA3Z=FALSE
MenuEfektowSpecjalnychAudio=("$ESA1" "$ESA2" "$ESA3")
ESG1="Odwrocenie obrazu do gory nogami"
    ESG1Z=FALSE
ESG2="Obraz czarno-biały"
    ESG2Z=FALSE
ESG3="Zmiana wysokosci i szerokosci"
    ESG3Z=FALSE
MenuEfektowSpecjalnychGraficznych=("$ESG1" "$ESG2" "$ESG3")

function sprawdzTypPliku(){
    if [[ $Plik == *.avi ]] || [[ $Plik == *.mp4 ]] || [[ $Plik == *.flv ]] || [[ $Plik == *.webm ]] || [[ $Plik == *.mov ]] || [[ $Plik == *.m4v ]]; then
        Lista=0
    elif [[ $Plik == *.mp3 ]] || [[ $Plik == *.wav ]] || [[ $Plik == *.flac ]]; then
        Lista=1
    elif [[ $Plik == *.jpeg ]] || [[ $Plik == *.jpg ]] || [[ $Plik == *.png ]] || [[ $Plik == *.gif ]] || [[ $Plik == *.bmp ]] || [[ $Plik == *.tga ]] || [[ $Plik == *.tiff ]]; then
        Lista=2
    else Lista=3
    fi
}
rc=0
opcja=0
while [ "$opcja" != 8 ]
do
m1="1. Plik do konwersji: $Plik"
m2="2. Wybierz format pliku: $Format"
m3="3. Nazwa docelowa: $DocelowyPlik"
m4="4. Efekty specjalne"
m5="5. Konwertuj Plik"
m6="6. Pomocy"
m7="7. Wersja"
m8="8. Koniec"
Menu=("$m1" "$m2" "$m3" "$m4" "$m5" "$m6" "$m7" "$m8")
opcja=$(zenity --list --column=Menu "${Menu[@]}" --height 300 --width 500 --cancel-label "Wyjdź")
rc=$?
clear
if [ "$rc" -eq 1 ];then
    zenity --question --title "Zakończenie programu" --text "Czy napewno chcesz zakończyć działanie programu?" --width 200
    if [ $? == 0 ]; then
        exit
    else
        opcja=0
    fi
fi
if [ "$opcja" == "$m1" ];then
	Plik=$(zenity --file-selection --title "Wybierz plik")
    sprawdzTypPliku
    if [ "$Lista" -eq 3 ]; then 
        Format=""
    fi
    if [ "$Temp" != "$Lista" ]; then
        DocelowyPlik=""
        Format=""
        Obrot=0
        CzarB=0
        PredA=0
        PredV=0
        Odwr=0
        Echo=0
        Tmpo=0
        OObrot=0
        OCzarB=0
        Rozm=0
        ESV1Z=FALSE
        ESV2Z=FALSE
        ESV3Z=FALSE
        ESA1Z=FALSE
        ESA2Z=FALSE
        ESA3Z=FALSE
        ESG1Z=FALSE
        ESG2Z=FALSE
        ESG3Z=FALSE
    fi
    Temp=$Lista
elif [ "$opcja" == "$m2" ];then
if [[ "$Lista" -eq 0 ]]; then
    Format=$(zenity --list --column="Wybierz format" "${MenuFormatowVideo[@]}" --height 250)
elif [[ "$Lista" -eq 1 ]]; then
    Format=$(zenity --list --column="Wybierz format" "${MenuFormatowAudio[@]}" --height 250)
elif [[ "$Lista" -eq 2 ]]; then
    Format=$(zenity --list --column="Wybierz format" "${MenuFormatowGraficznych[@]}" --height 250)
elif [[ "$Lista" -eq 3 ]];then
    zenity --error --text "Proszę wybierz plik z prawidłowym formatem" --width 200
fi
if [ -z "$Format" ]; then
    DocelowyPlik=""
else SciezkaDoPliku=$(grep |find "$Plik" | cut -d '.' -f 1)
    DocelowyPlik="$SciezkaDoPliku$Format"
    NazwaPliku=$(grep | find "$Plik" | cut -d '.' -f 1 | rev | cut -d '/' -f 1 | rev)
    Sciezka=$(grep |find "$Plik" | sed -e "s/\<$NazwaPliku\>//g" | cut -d '.' -f 1)
fi
elif [ "$opcja" == "$m3" ];then
    if [ -n "$Plik" ];then
        if [ -n "$Format" ];then
            a=$(zenity --file-selection --title "Wybierz folder, w którym zostanie zapisany nowy plik" --directory)
            DocelowaNazwa=$(zenity --entry --title "Podaj nazwę nowego pliku" --text "" --width 350)
            if [ -z "$a" ] && [ -z "$DocelowaNazwa" ];then
                DocelowyPlik="$SciezkaDoPliku$Format"
            elif [ -z "$a" ];then
                DocelowyPlik="$Sciezka$DocelowaNazwa$Format"
            elif [ -z "$DocelowaNazwa" ];then
                DocelowyPlik="$a/$NazwaPliku$Format"
            else
                DocelowyPlik="$a/$DocelowaNazwa$Format"
            fi
        else
            zenity --error --text "Proszę wybierz format pliku" --width 200
        fi
    else
        zenity --error --text "Proszę wybierz plik do konwertowania" --width 200
    fi
elif [ "$opcja" == "$m4" ];then
    if [[ "$Lista" -eq 0 ]]; then
    EfektSpecjalny=$(zenity --list --checklist --column="Zaznacz" --column="Wybierz efekty specjalne" "$ESV1Z" "$ESV1" "$ESV2Z" "$ESV2" "$ESV3Z" "$ESV3" --height 250 --width 300 --separator=":")
        if [[ "$EfektSpecjalny" == "$ESV1:$ESV2:$ESV3" ]];then
            ESV1Z=TRUE
            ESV2Z=TRUE
            ESV3Z=TRUE
            Obrot=1
            CzarB=1
            Pred=1
            Predkosc=$(zenity --scale --text "Wskaż nowe tempo [%]:" --min-value 50 --max-value 200 --value 100)
        elif [[ "$EfektSpecjalny" == "$ESV1:$ESV2" ]];then
            ESV1Z=TRUE
            ESV2Z=TRUE
            ESV3Z=FALSE
            Obrot=1
            CzarB=1
            Pred=0
        elif [[ "$EfektSpecjalny" == "$ESV1:$ESV3" ]];then
            ESV1Z=TRUE
            ESV2Z=FALSE
            ESV3Z=TRUE
            Obrot=1
            CzarB=0
            Pred=1
            Predkosc=$(zenity --scale --text "Wskaż nowe tempo [%]:" --min-value 50 --max-value 200 --value 100)
        elif [[ "$EfektSpecjalny" == "$ESV2:$ESV3" ]];then
            ESV1Z=FALSE
            ESV2Z=TRUE
            ESV3Z=TRUE
            Obrot=0
            CzarB=1
            Pred=1
            Predkosc=$(zenity --scale --text "Wskaż nowe tempo [%]:" --min-value 50 --max-value 200 --value 100)
        elif [[ "$EfektSpecjalny" == "$ESV1" ]];then
            ESV1Z=TRUE
            ESV2Z=FALSE
            ESV3Z=FALSE
            Obrot=1
            CzarB=0
            Pred=0
        elif [[ "$EfektSpecjalny" == "$ESV2" ]];then
            ESV1Z=FALSE
            ESV2Z=TRUE
            ESV3Z=FALSE
            Obrot=0
            CzarB=1
            Pred=0
        elif [[ "$EfektSpecjalny" == "$ESV3" ]];then
            ESV1Z=FALSE
            ESV2Z=FALSE
            ESV3Z=TRUE
            Obrot=0
            CzarB=0
            Pred=1
            Predkosc=$(zenity --scale --text "Wskaż nowe tempo [%]:" --min-value 50 --max-value 200 --value 100)
        else
            ESV1Z=FALSE
            ESV2Z=FALSE
            ESV3Z=FALSE
            Obrot=0
            CzarB=0
            Pred=0
        fi
elif [[ "$Lista" -eq 1 ]]; then
EfektSpecjalny=$(zenity --list --checklist --column="Zaznacz" --column="Wybierz efekty specjalne" "$ESA1Z" "$ESA1" "$ESA2Z" "$ESA2" "$ESA3Z" "$ESA3" --height 250 --width 300 --separator=":")
        if [[ "$EfektSpecjalny" == "$ESA1:$ESA2:$ESA3" ]];then
            ESA1Z=TRUE
            ESA2Z=TRUE
            ESA3Z=TRUE
            Odwr=1
            Echo=1
            Tmpo=1
            Tempo=$(zenity --scale --text "Wskaż nowe tempo [%]:" --min-value 50 --max-value 200 --value 100)
        elif [[ "$EfektSpecjalny" == "$ESA1:$ESA2" ]];then
            ESA1Z=TRUE
            ESA2Z=TRUE
            ESA3Z=FALSE
            Odwr=1
            Echo=1
            Tmpo=0
        elif [[ "$EfektSpecjalny" == "$ESA1:$ESA3" ]];then
            ESA1Z=TRUE
            ESA2Z=FALSE
            ESA3Z=TRUE
            Odwr=1
            Echo=0
            Tmpo=1
            Tempo=$(zenity --scale --text "Wskaż nowe tempo [%]:" --min-value 50 --max-value 200 --value 100)
        elif [[ "$EfektSpecjalny" == "$ESA2:$ESA3" ]];then
            ESA1Z=FALSE
            ESA2Z=TRUE
            ESA3Z=TRUE
            Odwr=0
            Echo=1
            Tmpo=1
            Tempo=$(zenity --scale --text "Wskaż nowe tempo [%]:" --min-value 50 --max-value 200 --value 100)
        elif [[ "$EfektSpecjalny" == "$ESA1" ]];then
            ESA1Z=TRUE
            ESA2Z=FALSE
            ESA3Z=FALSE
            Odwr=1
            Echo=0
            Tmpo=0
        elif [[ "$EfektSpecjalny" == "$ESA2" ]];then
            ESA1Z=FALSE
            ESA2Z=TRUE
            ESA3Z=FALSE
            Odwr=0
            Echo=1
            Tmpo=0
        elif [[ "$EfektSpecjalny" == "$ESA3" ]];then
            ESA1Z=FALSE
            ESA2Z=FALSE
            ESA3Z=TRUE
            Odwr=0
            Echo=0
            Tmpo=1
            Tempo=$(zenity --scale --text "Wskaż nowe tempo [%]:" --min-value 50 --max-value 200 --value 100)
        else
            ESA1Z=FALSE
            ESA2Z=FALSE
            ESA3Z=FALSE
            Odwr=0
            Echo=0
            Tmpo=0
        fi
elif [[ "$Lista" -eq 2 ]]; then
    EfektSpecjalny=$(zenity --list --checklist --column="Zaznacz" --column="Wybierz efekty specjalne" "$ESG1Z" "$ESG1" "$ESG2Z" "$ESG2" "$ESG3Z" "$ESG3" --height 250 --width 350 --separator=":")
    if [[ "$EfektSpecjalny" == "$ESG1:$ESG2:$ESG3" ]];then
            ESG1Z=TRUE
            ESG2Z=TRUE
            ESG3Z=TRUE
            OObrot=1
            OCzarB=1
            Rozm=1
            Wysokosc=$(zenity --scale --text "Wskaż nowy rozmiar wysokości [%]:" --min-value 50 --max-value 200 --value 100)
            Szerokosc=$(zenity --scale --text "Wskaż nowy rozmiar szerokości [%]:" --min-value 50 --max-value 200 --value 100)
        elif [[ "$EfektSpecjalny" == "$ESG1:$ESG2" ]];then
            ESG1Z=TRUE
            ESG2Z=TRUE
            ESG3Z=FALSE
            OObrot=1
            OCzarB=1
            Rozm=0
        elif [[ "$EfektSpecjalny" == "$ESG1:$ESG3" ]];then
            ESG1Z=TRUE
            ESG2Z=FALSE
            ESG3Z=TRUE
            OObrot=1
            OCzarB=0
            Rozm=1
            Wysokosc=$(zenity --scale --text "Wskaż nowy rozmiar wysokości [%]:" --min-value 50 --max-value 200 --value 100)
            Szerokosc=$(zenity --scale --text "Wskaż nowy rozmiar szerokości [%]:" --min-value 50 --max-value 200 --value 100)
        elif [[ "$EfektSpecjalny" == "$ESG2:$ESG3" ]];then
            ESG1Z=FALSE
            ESG2Z=TRUE
            ESG3Z=TRUE
            OObrot=0
            OCzarB=1
            Rozm=1
            Wysokosc=$(zenity --scale --text "Wskaż nowy rozmiar wysokości [%]:" --min-value 50 --max-value 200 --value 100)
            Szerokosc=$(zenity --scale --text "Wskaż nowy rozmiar szerokości [%]:" --min-value 50 --max-value 200 --value 100)
        elif [[ "$EfektSpecjalny" == "$ESG1" ]];then
            ESG1Z=TRUE
            ESG2Z=FALSE
            ESG3Z=FALSE
            OObrot=1
            OCzarB=0
            Rozm=0
        elif [[ "$EfektSpecjalny" == "$ESG2" ]];then
            ESG1Z=FALSE
            ESG2Z=TRUE
            ESG3Z=FALSE
            OObrot=0
            OCzarB=1
            Rozm=0
        elif [[ "$EfektSpecjalny" == "$ESG3" ]];then
            ESG1Z=FALSE
            ESG2Z=FALSE
            ESG3Z=TRUE
            OObrot=0
            OCzarB=0
            Rozm=1
            Wysokosc=$(zenity --scale --text "Wskaż nowy rozmiar wysokości [%]:" --min-value 50 --max-value 200 --value 100)
            Szerokosc=$(zenity --scale --text "Wskaż nowy rozmiar szerokości [%]:" --min-value 50 --max-value 200 --value 100)
        else
            ESG1Z=FALSE
            ESG2Z=FALSE
            ESG3Z=FALSE
            OObrot=0
            OCzarB=0
            Rozm=0
        fi
elif [[ "$Lista" -eq 3 ]]; then
zenity --error --text "Proszę wybierz plik z prawidłowym formatem" --width 200
Errr=1
fi
elif [ "$opcja" == "$m5" ];then
if [ -z "$Plik" ] || [ -z "$Format" ]; then
zenity --error --text "Nie wszystkie opcje zostały wybrane" --width 200
fi
Errr=1
if [[ "$Lista" -eq 0 ]] && [ -n "$DocelowyPlik" ]; then
    Errr=0
    if [[ Predkosc -lt 100 ]];then            
            tempPredkosc=$Predkosc
            PredA="0."$Predkosc""
            PredV="1."$((10000/$tempPredkosc-100))""
        elif [[ Predkosc -lt 200 ]];then
            tempPredkosc=$Predkosc
            PredA="1."$(($Predkosc-100))""
            PredV="0."$((10000/$tempPredkosc))""
        elif [[ Predkosc -eq 200 ]];then
            PredA="2"
            PredV="0.5"
    fi
    if [[ "$Obrot" -eq 1 && "$CzarB" -eq 1 && "$Pred" -eq 1 ]];then
        Efekty="-vf vflip,hflip,format=gray,setpts=$PredV*PTS -af atempo=$PredA,aresample=44100"
    elif [[ "$Obrot" -eq 1 && "$CzarB" -eq 1 ]]; then
        Efekty="-vf vflip,hflip,format=gray"
    elif [[ "$Obrot" -eq 1 && "$Pred" -eq 1 ]]; then
        Efekty="-vf vflip,hflip,setpts=$PredV*PTS -af atempo=$PredA,aresample=44100"
    elif [[ "$CzarB" -eq 1 && "$Pred" -eq 1 ]]; then
        Efekty="-vf format=gray,setpts=$PredV*PTS -af atempo=$PredA,aresample=44100"
    elif [[ "$Obrot" -eq 1 ]]; then
        Efekty="-vf vflip,hflip"
    elif [[ "$CzarB" -eq 1 ]]; then
        Efekty="-vf format=gray"
    elif [[ "$Pred" -eq 1 ]]; then
        Efekty="-filter_complex [0:v]setpts=$PredV*PTS[v];[0:a]atempo=$PredA[a];[0:a]asetrate=44100*$PredA,aresample=44100 -map [v] -map [a]"
    else
        Efekty=""
    fi
zenity --question --title "Ekran koncowy" --width 300 --ok-label "Konwertuj" --cancel-label "Cofnij"
if [[ "$?" -eq 0 ]]; then
ffmpeg -y -i "$Plik" $Efekty "$DocelowyPlik"
fi
elif [[ "$Lista" -eq 1 ]] && [ -n "$DocelowyPlik" ]; then
Errr=0
    if [[ Tempo -lt 100 ]];then
            Tempo="0."$Tempo""
        elif [[ Tempo -lt 200 ]];then
            Tempo="1."$(($Tempo-100))""
        elif [[ Tempo -eq 200 ]];then
            Tempo="2"
    fi
    if [[ "$Odwr" -eq 1 && "$Echo" -eq 1 && "$Tmpo" -eq 1 ]];then
        Efekty="-af atempo=$Tempo,aecho=in_gain=0.6:out_gain=0.3:delays='200',areverse"
    elif [[ "$Odwr" -eq 1 && "$Echo" -eq 1 ]]; then
        Efekty="-af aecho=in_gain=0.6:out_gain=0.3:delays='200',areverse"
    elif [[ "$Odwr" -eq 1 && "$Tmpo" -eq 1 ]]; then
        Efekty="-af atempo=$Tempo,areverse"
    elif [[ "$Echo" -eq 1 && "$Tmpo" -eq 1 ]]; then
        Efekty="-af atempo="$Tempo",aecho=in_gain=0.6:out_gain=0.3:delays='200'"
    elif [[ "$Odwr" -eq 1 ]]; then
        Efekty="-af areverse"
    elif [[ "$Echo" -eq 1 ]]; then
        Efekty="-af aecho=in_gain=0.6:out_gain=0.3:delays='200'"
    elif [[ "$Tmpo" -eq 1 ]]; then
        Efekty="-af atempo="$Tempo""
    else
        Efekty=""
    fi
zenity --question --title "Ekran koncowy" --width 300 --ok-label "Konwertuj" --cancel-label "Cofnij"
if [[ "$?" -eq 0 ]]; then
ffmpeg -y -i "$Plik" $Efekty "$DocelowyPlik"
fi
elif [[ "$Lista" -eq 2 ]] && [ -n "$DocelowyPlik" ]; then
    Errr=0
    if [[ "$OObrot" -eq 1 && "$OCzarB" -eq 1 && "$Rozm" -eq 1 ]];then
        Efekty="-rotate -180, -colorspace Gray, -resize "$Wysokosc"x"$Szerokosc"%"
    elif [[ "$OObrot" -eq 1 && "$OCzarB" -eq 1 ]]; then
        Efekty="-rotate -180, -colorspace Gray"
    elif [[ "$OObrot" -eq 1 && "$Rozm" -eq 1 ]]; then
        Efekty="-rotate -180, -resize "$Wysokosc"x"$Szerokosc"%"
    elif [[ "$OCzarB" -eq 1 && "$Rozm" -eq 1 ]]; then
        Efekty="-colorspace Gray, -resize "$Wysokosc"x"$Szerokosc"%"
    elif [[ "$OObrot" -eq 1 ]]; then
        Efekty="-rotate -180"
    elif [[ "$OCzarB" -eq 1 ]]; then
        Efekty="-colorspace Gray"
    elif [[ "$Rozm" -eq 1 ]]; then
        Efekty="-resize "$Wysokosc"x"$Szerokosc"%"
    else
        Efekty=""
    fi
    zenity --question --title "Ekran koncowy" --width 300 --ok-label "Konwertuj" --cancel-label "Cofnij"
    if [[ "$?" -eq 0 ]]; then
        convert "$Plik" $Efekty "$DocelowyPlik"
    fi
elif [[ "$Lista" -eq 3 ]] && [[ "$Errr" -eq 0 ]]; then
    Errr=0
    zenity --error --text "Proszę wybierz plik z prawidłowym formatem" --width 200
    fi
elif [ "$opcja" == "$m6" ];then
    zenity --text-info  --title="POMOCY" --width 450 --height 300 --filename=./README
elif [ "$opcja" == "$m7" ];then
    zenity --text-info  --title="WERSJA" --width 450 --height 300 --filename=./VERSION
elif [ "$opcja" == "$m8" ]; then
    zenity --question --title "Zakończenie programu" --text "Czy napewno chcesz zakończyć działanie programu?" --width 200
    if [ $? == 0 ]; then
        exit
    else
        opcja=0
    fi
fi
done
}

while getopts "vh" options; do

    case "${options}" in
        v)
            cat ./VERSION
            ;;
        h)
            cat ./README
            ;;
        *)
            main
            ;;
    esac
done
main
