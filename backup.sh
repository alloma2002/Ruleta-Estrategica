#!/bin/bash


#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"



function crtl_c(){
  echo -e "\n\n${redColour}[!] Saliendo...${endColour}\n"
  tput cnorm; exit 1

}


# Ctrl+C
 trap crtl_c INT 



#HelpPanel
function helpPanel(){

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Usos:${endColour} ${purpleColour}$0${endColour}\n"

  echo -e "\t${blueColour}./ruleta.sh -m <dinero> -t <técnica>${endColour}\n"

  echo -e "\t${yellowColour}-m)${endColour}${grayColour} Dinero con el que se desea jugar${endColour}"

  echo -e "\t${yellowColour}-t)${endColour}${grayColour} Técnica a utilizar${endColour}${purpleColour} (${endColour}${yellowColour}martingala${endColour}${purpleColour}/${endColour}${yellowColour}inverseLabrouchere${endColour}${purpleColour})${endColour}"

  echo -e "\t${yellowColour}-h)${endColour} ${grayColour}Mostrar este panel de ayuda${endColour}\n"

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ejemplo:${endColour}\n"

  echo -e "\t${blueColour}./ruleta.sh${endColour} -m 150 -t inverseLabrouchere\n"

  exit 1
  
}





#Martingala
function martingala(){

  tput civis

  echo -e "\n${purpleColour}===================================================${endColour}"
  echo -e "${purpleColour}==${endColour}${yellowColour}         RULETA ESTRATÉGICA - MARTINGALA         ${endColour}${purpleColour}==${endColour}"
  echo -e "${purpleColour}===================================================${endColour}\n"

  echo -e "${yellowColour}[*]${endColour} ${grayColour}Reglas de la estrategia:${endColour}"
  echo -e "\t${blueColour}1.${endColour} ${grayColour}Apuesta inicial: La cantidad que elijas.${endColour}"
  echo -e "\t${blueColour}2.${endColour} ${grayColour}Si ganas: Mantienes la apuesta inicial.${endColour}"
  echo -e "\t${blueColour}3.${endColour} ${grayColour}Si pierdes: Doblas la apuesta anterior ${endColour}${purpleColour}(2€ -> 4€ -> 8€)${endColour}"
  echo -e "\t${blueColour}4.${endColour} ${grayColour}Objetivo: Recuperar pérdidas y ganar la apuesta inicial.${endColour}"

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Preparando mesa...${endColour}"
  sleep 5

  tput cnorm

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money€ ${endColour}"

  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿Cuánto dinero tienes pensado apostar? -> ${endColour}" && read initial_bet

  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Vamos a jugar con una cantidad inicial de ${endColour} ${yellowColour}$initial_bet€${endColour} ${grayColour}a${endColour} ${yellowColour}$par_impar${endColour}\n"

  backup_bet=$initial_bet

  play_counter=1

  jugadas_malas=""

  max_money=$money

  tput civis
 while true; do

   echo -e "\n${grayColour}----------------------------------------------------${endColour}"

   money=$(($money-$initial_bet))

   echo -e "\n${yellowColour}[+]${endColour}${grayColour} Acabas de apostar${endColour} ${yellowColour}$initial_bet€${endColour} ${grayColour}y tienes un total de${endColour} ${yellowColour}$money€${endColour}"

   echo -ne "${purpleColour}[...] Tirando la bola...${endColour}"
   sleep 0.5

   random_number="$(($RANDOM % 37))"


   if [  "$money" -ge 0 ]; then

   echo -e "\n${yellowColour}[+]${endColour}${grayColour} Ha salido el número${endColour} ${yellowColour}$random_number${endColour}"

   if [ "$par_impar" == "par" ]; then
     #Apostar a números pares
    if [ "$(($random_number % 2))" -eq 0 ]; then

     if [ $random_number -eq 0 ]; then

        echo -e "${redColour}[!]${endColour} ${grayColour}Ha salido el 0, por tanto${endColour} ${redColour}has perdido${endColour}"

        initial_bet=$(($initial_bet*2))

        echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes un total de${endColour} ${yellowColour}$money€${endColour}\n"

     else

     echo -e "${greenColour}[+]${endColour}${grayColour} El numero que ha salido es par,${endColour}${greenColour}¡Ganas!${endColour}" 

     reward=$(($initial_bet*2))

     echo -e "${yellowColour}[+]${endColour}${grayColour} Ganas un total de${endColour} ${yellowColour}$reward€${endColour}"
     money=$(($reward+$money))
        if [ $money -gt $max_money ]; then
        max_money=$money
        fi
     echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes un total de${endColour} ${yellowColour}$money€${endColour}\n"
     initial_bet=$backup_bet
     jugadas_malas=""

     fi

     else
       echo -e "${redColour}[+]${endColour} ${grayColour}El numero que ha salido es impar, ${endColour}${redColour}¡Pierdes!${endColour}"
       initial_bet=$(($initial_bet*2))
       jugadas_malas+="$random_number "
       echo -e "${yellowColour}[+]${endColour}${grayColour} Tienes un total de${endColour} ${yellowColour}$money€${endColour}\n" 
       

     fi 
     
    else
      #Apostar a números Impares
      if [ "$(($random_number % 2))" -eq 1 ]; then

        echo -e "${greenColour}[+]${endColour}${grayColour} El número que ha salido es impar,${endColour}${greenColour} ¡Ganas!${endColour}"
        reward=$(($initial_bet*2))
        echo -e "${yellowColour}[+]${endColour} ${grayColour}Ganas un total de $reward€${endColour}"
        money=$(($reward+$money))
         if [ $money -gt $max_money ]; then
           max_money=$money
         fi
        echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes un total de $money€${grayColour}"
        initial_bet=$backup_bet
        jugadas_malas=""

        else
      
          echo -e "${redColour}[!]${endColour} ${grayColour}El número que ha salido es par,${endColour} ${redColour}¡Pierdes!${endColour}"
          initial_bet=$(($initial_bet*2))
          jugadas_malas+="$random_number "
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes un total de $money€${endColour}"

      fi
    fi

   else
   #Cuanto te quedas a 0

   echo -e "\n\n${redColour}====================================================${endColour}"
     echo -e "${redColour}[!] FIN DEL JUEGO: Te has quedado sin blanca${endColour}"
     echo -e "${redColour}====================================================${endColour}"
     
     echo -e "\n${grayColour}Resumen de la sesión:${endColour}"
     echo -e "\t${blueColour}• Jugadas totales:${endColour} ${yellowColour}$((play_counter-1))${endColour}"
     echo -e "\t${blueColour}• Pico de dinero:${endColour} ${greenColour}$max_money€${endColour}"
     echo -e "\t${blueColour}• Mala racha final:${endColour} ${redColour}[ $jugadas_malas]${endColour}\n"

   tput cnorm; exit 0
     fi
    
     let play_counter+=1

   done



   tput cnorm
  }


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------




function inverseLabrouchere(){

  tput civis

  echo -e "\n${purpleColour}======================================================================${endColour}"
  echo -e "${purpleColour}==${endColour}${yellowColour}             RULETA ESTRATÉGICA - INVERSE LABROUCHERE         ${endColour}${purpleColour}   ==${endColour}"
  echo -e "${purpleColour}======================================================================${endColour}\n"

  echo -e "${yellowColour}[*]${endColour} ${grayColour}Reglas de la estrategia:${endColour}"
  echo -e "\t${blueColour}1.${endColour} ${grayColour}Secuencia inicial: ${endColour}${yellowColour}1 2 3 4${endColour}"
  echo -e "\t${blueColour}2.${endColour} ${grayColour}Apuesta: Suma de extremos ${endColour}${purpleColour}(1+4 = 5€)${endColour}"
  echo -e "\t${blueColour}3.${endColour} ${grayColour}Si ganas: Añades apuesta al final ${endColour}${purpleColour}(1 2 3 4 5)${endColour}"
  echo -e "\t${blueColour}4.${endColour} ${grayColour}Si pierdes: Eliminas los dos extremos ${endColour}${purpleColour}(2 3)${endColour}"
  echo -e "\t${blueColour}5.${endColour} ${grayColour}Checkpoint: Reset a 1 2 3 4 cada +50€ de beneficio.${endColour}"

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Preparando mesa...${endColour}"
  sleep 5
  tput cnorm

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Dinero actual:${endColour}${yellowColour} $money€ ${endColour}"
  echo -ne "${yellowColour}[+]${endColour}${grayColour} ¿A qué deseas apostar continuamente (par/impar)? -> ${endColour}" && read par_impar

  declare -a my_sequence=(1 2 3 4)

  echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Comenzamos con la secuencia${endColour} ${yellowColour}[${my_sequence[*]}]${endColour}"

  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
  max_money=$money
  
  jugadas_totales=0
  bet_to_renew=$(($money+50)) 
  echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope a renovar la secuencia esta establecido por encima de los${endColour} ${yellowColour}$bet_to_renew€${endColour}"

  tput civis

  while true; do

    let jugadas_totales+=1

    random_number=$(($RANDOM % 37))

    money=$(($money - $bet))

    sleep 0.7 

    
    if [ ! "$money" -lt 0 ]; then

      
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Invertimos${endColour} ${yellowColour}$bet€${endColour}"
      echo -e "${yellowColour}[+]${endColour} ${grayColour}Tenemos${endColour} ${yellowColour}$money€${endColour}"

      echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Ha salido el número${endColour} ${yellowColour}$random_number${endColour}"

      if [ "$par_impar" == "par" ]; then
        if [ "$(($random_number % 2))" -eq 0 ] && [ "$random_number" -ne 0 ]; then
        echo -e "${greenColour}[+]${endColour} ${grayColour}El número es par,${endColour} ${greenColour}¡Ganas!${endColour}"
        reward=$(($bet * 2))
        let money+=$reward
        if [ "$money" -gt "$max_money" ]; then
        max_money=$money
        fi
        echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money€${endColour}"

        if [ "$money" -gt $bet_to_renew ]; then
          echo -e "${yellowColour}[+]${endColour} ${grayColour}Se ha superado el tope establecido de${endColour} ${yellowColour}$bet_to_renew€${endColour} ${grayColour}para renovar nuestra secuencia${endColour}"
          bet_to_renew=$(($bet_to_renew + 50))
          echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope se ha establecido en${endColour} ${yellowColour}$bet_to_renew${endColour}"
          my_sequence=(1 2 3 4)
          bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          echo -e "${yellowColour}[+]${endColour} ${grayColour}La secuencia ha sido restablecida a${endColour} ${yellowColour}[${my_sequence[*]}]${endColour}"

          elif [ "$money" -lt "$(($bet_to_renew - 100))" ]; then
            
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Se ha alcanzado a un mínimo crítico, se procede a reajustar el tope${endColour}"
            bet_to_renew=$(($bet_to_renew - 50))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${yellowColour}$bet_to_renew${endColour}"
            
            my_sequence+=($bet)
           my_sequence=(${my_sequence[*]})
           echo -e "${yellowColour}[+]${endColour}${grayColour} La nueva secuencia es${endColour} ${yellowColour}[${my_sequence[*]}]${endColour}"

          if [ "${#my_sequence[*]}" -ne 1 ] && [ "${#my_sequence[*]}" -ne 0 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[*]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else
              echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${yellowColour} [${my_sequence[*]}] ${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          fi 

          else
           my_sequence+=($bet)
           my_sequence=(${my_sequence[*]})
           echo -e "${yellowColour}[+]${endColour}${grayColour} La nueva secuencia es${endColour} ${yellowColour}[${my_sequence[*]}]${endColour}"

          if [ "${#my_sequence[*]}" -ne 1 ] && [ "${#my_sequence[*]}" -ne 0 ]; then
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          elif [ "${#my_sequence[*]}" -eq 1 ]; then
            bet=${my_sequence[0]}
          else
            echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
            my_sequence=(1 2 3 4)
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${yellowColour} [${my_sequence[*]}] ${endColour}"
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          fi 
        fi

      elif [ "$(($random_number % 2))" -eq 1 ] || [ "$(($random_number % 2))" -eq 0 ]; then
        if [ "$(($random_number % 2))" -eq 1 ]; then
        echo -e "${redColour}[!]${endColour} ${grayColour}El número es impar,${endColour} ${redColour}¡Pierdes!${endColour}"
        else
        echo -e "${redColour}[!]${endColour}${grayColour} ¡Es el${endColour}${yellowColour} 0!${endColour} ${grayColour}La casa se lo lleva todo${endColour} ${redColour}¡Pierdes!${endColour}"
        fi

        if [ "$money" -lt "$(($bet_to_renew - 100))" ]; then
            
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Se ha alcanzado a un mínimo crítico, se procede a reajustar el tope${endColour}"
            bet_to_renew=$(($bet_to_renew - 50))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${yellowColour}$bet_to_renew${endColour}"
           
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[*]})

            echo -e "${yellowColour}[+]${endColour}${grayColour} La nueva secuencia es${endColour} ${yellowColour}[${my_sequence[*]}]${endColour}"

          if [ "${#my_sequence[*]}" -ne 1 ] && [ "${#my_sequence[*]}" -ne 0 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[*]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else
              echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${yellowColour} [${my_sequence[*]}] ${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
          fi 

          else

            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[*]})

           if [ "$money" -gt 0 ]; then
            echo -e "${yellowColour}[+]${endColour} ${grayColour}La secuencia se nos queda de la siguiente forma: ${endColour}${yellowColour}[${my_sequence[*]}]${endColour}"

              if [ "${#my_sequence[*]}" -ne 1 ] && [ "${#my_sequence[*]}" -ne 0 ]; then
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              elif [ "${#my_sequence[*]}" -eq 1 ]; then
                bet=${my_sequence[0]}
               else
                if [ "$money" -gt 0 ]; then
                 echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                 my_sequence=(1 2 3 4)
                echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${yellowColour} [${my_sequence[*]}] ${endColour}"
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                fi
              fi
             fi
           fi
         fi
        
        elif [ "$par_impar" == "impar" ]; then
        if [ "$(($random_number % 2))" -eq 1 ]; then
          echo -e "${greenColour}[+]${endColour} ${grayColour}El número es impar,${endColour} ${greenColour}¡Ganas!${endColour}"
          reward=$(($bet * 2))
          let money+=$reward
          if [ "$money" -gt "$max_money" ]; then
          max_money=$money
          fi

          echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money€${endColour}"

          if [ "$money" -gt $bet_to_renew ]; then
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Se ha superado el tope establecido de${endColour} ${yellowColour}$bet_to_renew€${endColour} ${grayColour}para renovar nuestra secuencia${endColour}"
            bet_to_renew=$(($bet_to_renew + 50))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope se ha establecido en${endColour} ${yellowColour}$bet_to_renew${endColour}"
            my_sequence=(1 2 3 4)
            bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}La secuencia ha sido restablecida a${endColour} ${yellowColour}[${my_sequence[*]}]${endColour}"
          elif [ "$money" -lt "$(($bet_to_renew - 100))" ]; then
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Se ha alcanzado a un mínimo crítico, se procede a reajustar el tope${endColour}"
            bet_to_renew=$(($bet_to_renew - 50))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${yellowColour}$bet_to_renew${endColour}"
            my_sequence+=($bet)
            my_sequence=(${my_sequence[*]})
            echo -e "${yellowColour}[+]${endColour}${grayColour} La nueva secuencia es${endColour} ${yellowColour}[${my_sequence[*]}]${endColour}"
            if [ "${#my_sequence[*]}" -ne 1 ] && [ "${#my_sequence[*]}" -ne 0 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[*]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else
              echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${yellowColour} [${my_sequence[*]}] ${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi
          else
            my_sequence+=($bet)
            my_sequence=(${my_sequence[*]})
            echo -e "${yellowColour}[+]${endColour}${grayColour} La nueva secuencia es${endColour} ${yellowColour}[${my_sequence[*]}]${endColour}"
            if [ "${#my_sequence[*]}" -ne 1 ] && [ "${#my_sequence[*]}" -ne 0 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[*]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else
              echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${yellowColour} [${my_sequence[*]}] ${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi
          fi

        elif [ "$(($random_number % 2))" -eq 0 ]; then
          if [ "$random_number" -eq 0 ]; then
            echo -e "${redColour}[!]${endColour}${grayColour} ¡Es el${endColour}${yellowColour} 0!${endColour} ${grayColour}La casa se lo lleva todo${endColour} ${redColour}¡Pierdes!${endColour}"
          else
            echo -e "${redColour}[!]${endColour} ${grayColour}El número es par,${endColour} ${redColour}¡Pierdes!${endColour}"
          fi

          if [ "$money" -lt "$(($bet_to_renew - 100))" ]; then
            echo -e "${yellowColour}[+]${endColour} ${grayColour}Se ha alcanzado a un mínimo crítico, se procede a reajustar el tope${endColour}"
            bet_to_renew=$(($bet_to_renew - 50))
            echo -e "${yellowColour}[+]${endColour} ${grayColour}El tope ha sido renovado a${endColour} ${yellowColour}$bet_to_renew${endColour}"
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[*]})
            echo -e "${yellowColour}[+]${endColour}${grayColour} La nueva secuencia es${endColour} ${yellowColour}[${my_sequence[*]}]${endColour}"
            if [ "${#my_sequence[*]}" -ne 1 ] && [ "${#my_sequence[*]}" -ne 0 ]; then
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            elif [ "${#my_sequence[*]}" -eq 1 ]; then
              bet=${my_sequence[0]}
            else
              echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
              my_sequence=(1 2 3 4)
              echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${yellowColour} [${my_sequence[*]}] ${endColour}"
              bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
            fi
          else
            unset my_sequence[0]
            unset my_sequence[-1] 2>/dev/null
            my_sequence=(${my_sequence[*]})
            if [ "$money" -gt 0 ]; then
              echo -e "${yellowColour}[+]${endColour} ${grayColour}La secuencia se nos queda de la siguiente forma: ${endColour}${yellowColour}[${my_sequence[*]}]${endColour}"
              if [ "${#my_sequence[*]}" -ne 1 ] && [ "${#my_sequence[*]}" -ne 0 ]; then
                bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
              elif [ "${#my_sequence[*]}" -eq 1 ]; then
                bet=${my_sequence[0]}
              else
                if [ "$money" -gt 0 ]; then
                  echo -e "${redColour}[!] Hemos perdido nuestra secuencia${endColour}"
                  my_sequence=(1 2 3 4)
                  echo -e "${yellowColour}[+]${endColour} ${grayColour}Restablecemos la secuencia a${endColour} ${yellowColour} [${my_sequence[*]}] ${endColour}"
                  bet=$((${my_sequence[0]} + ${my_sequence[-1]}))
                fi
              fi
            fi
          fi
        fi
        
      fi
      
 else
       echo -e "\n\n${redColour}====================================================${endColour}"
     echo -e "${redColour}[!] FIN DEL JUEGO: Te has quedado sin blanca${endColour}"
     echo -e "${redColour}====================================================${endColour}"
     echo -e "\n${grayColour}Resumen de la sesión:${endColour}"
     echo -e "\t${blueColour}• Jugadas totales:${endColour} ${yellowColour}$jugadas_totales${endColour}"
     echo -e "\t${blueColour}• Dinero máximo alcanzado:${endColour} ${yellowColour}$max_money€${endColour}"



     tput cnorm; exit 1 
 fi
     
     
     #sleep 0.5
 done

  tput cnrom


}


#-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


 while getopts "m:t:h" arg; do
   case $arg in
     m) money=$OPTARG;;
     t) technique=$OPTARG;;
     h) helpPanel;;

   esac

 done



  if [ $money ] && [ $technique ]; then

    if [ "$technique" == "martingala" ]; then

      martingala

    elif [ "$technique" == "inverseLabrouchere" ]; then

      inverseLabrouchere

    else
    
      echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"

      helpPanel

    fi

 else

   helpPanel

 fi
