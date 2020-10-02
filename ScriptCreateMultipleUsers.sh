#!/bin/bash

user_basename=$1
number_of_user=$2
starting_number=$3

#//////////////////////////////////////[user_basename]/////////////////////////////////////////////////
#Gestion du nom de base en cas de non saisie
if [ -z "$user_basename" ]
then
  echo ""
  echo "Trop peu d'arguments !"
  echo "La synthaxe correcte est :"\
    "$0 [user_basename]"\
    "[number_of_user]"\
    "[starting_number]"
    echo "[user_basename] obligatoire ! Veuillez le saisir [0-9a-zA-Z] :"
  user_basename=""
  while [[ ! $user_basename =~ ^[0-9a-zA-Z]+$ ]]
  do
    read user_basename
  done

#Vérification du format du nom de base en cas de saisie
elif [ -n "$user_basename" ]
then
  if [[ ! $user_basename =~ ^[0-9a-zA-Z]+$ ]]
  then
    echo "format de [user_basename] incorrecte ! Veuillez le re-saisir [0-9a-zA-Z] :"
    user_basename=""
    while [[ ! $user_basename =~ ^[0-9a-zA-Z]+$ ]]
    do
      read user_basename
    done
  fi
fi

#//////////////////////////////////////[number_of_user]////////////////////////////////////////////////
#Gestion des valeurs par défaut du nombre d'utilisateurs en cas de non saisie
if [ -z "$number_of_user" ]
then
 echo "Pas de nombre d'utilisateurs à créer saisi, par défault un seul sera créé."
 echo "Voulez-vous saisir un nombre d'utilisateur à créer? [o,n]"
  read yesOrNo
  yesOrNo_valid=0
  yes="o"
  no="n"
  while [ $yesOrNo_valid -eq 0 ] #Boucle de validation des choix
  do
    if [ "$yesOrNo" == "$yes" ] || [ "$yesOrNo" == "$no" ]
    then
      yesOrNo_valid=1
      if [ "$yesOrNo" == "$yes" ]
      then
        echo "Saisissez le nombre d'utilisateurs à créer (un entier) :"
        number_of_user=""
        while [[ ! $number_of_user =~ ^[0-9]+$ ]] #Oblige à saisir un entier
        do
          read number_of_user
        done
      elif [ "$yesOrNo" == "$no" ]
      then
        number_of_user=1 #Par défaut le nombre d'utilisateur est de 1
      fi
    else
      echo "Veuillez saisir une valeur valide : [o ou n]"
      read yesOrNo
      if [ "$yesOrNo" == "$yes" ]
      then
        yesOrNo_valid=1
        echo "Saisissez le nombre d'utilisateurs à créer (un entier) :"
        number_of_user=""
        while [[ ! $number_of_user =~ ^[0-9]+$ ]] #Oblige à saisir un entier
        do
          read number_of_user
        done
      elif [ "$yesOrNo" == "$no" ]
      then
        yesOrNo_valid=1
        number_of_user=1 #Par défaut le nombre d'utilisateur est de 1
      fi
    fi
  done

#Vérification du format du nombre d'utilisateurs en cas de saisie
elif [ -n "$number_of_user" ]
number_of_user=$2
then
  if [[ ! $number_of_user =~ ^[0-9]+$ ]]
  then
    echo "format de [number_of_user] incorrecte ! Veuillez le re-saisir [0-9] :"
    number_of_user=""
    while [[ ! $number_of_user =~ ^[0-9]+$ ]]
    do
      read number_of_user
    done
  fi
fi

#//////////////////////////////////////[starting_number]///////////////////////////////////////////////
#Gestion des valeurs par défaut du nombre de départ en cas de non-saisie
if [ -z "$starting_number" ]
then
  echo "Pas de nombre de départ saisi, par défault le compteur débutera à 0."
  echo "Voulez-vous saisir un nombre de départ? [o,n]"
  read yesOrNo
  yesOrNo_valid=0
  yes="o"
  no="n"
  while [ $yesOrNo_valid -eq 0 ] #Boucle de validation des choix
  do
    if [ "$yesOrNo" == "$yes" ] || [ "$yesOrNo" == "$no" ]
    then
      yesOrNo_valid=1
      if [ "$yesOrNo" == "$yes" ]
      then
        echo "Saisissez le nombre de départ (un entier) :"
        starting_number=""
        while [[ ! $starting_number =~ ^[0-9]+$ ]] #Oblige à saisir un entier
        do
          read starting_number
        done
      elif [ "$yesOrNo" == "$no" ]
      then
        starting_number=0 #Par défaut le nombre d'utilisateur est de 1
      fi
    else
      echo "Veuillez saisir une valeur valide : [o ou n]"
      read yesOrNo
      if [ "$yesOrNo" == "$yes" ]
      then
        yesOrNo_valid=1
        echo "Saisissez le nombre de départ (un entier) :"
        starting_number=""
        while [[ ! $starting_number =~ ^[0-9]+$ ]] #Oblige à saisir un entier
        do
          read starting_number
        done
      elif [ "$yesOrNo" == "$no" ]
      then
        yesOrNo_valid=1
        starting_number=1 #Par défaut le nombre d'utilisateur est de 1
      fi
    fi
  done

#Vérification du format du nombre de départ en cas de saisie
elif [ -n "$starting_number" ]
starting_number=$3
then
  if [[ ! $starting_number =~ ^[0-9]+$ ]]
  then
    echo "format de [starting_number] incorrecte ! Veuillez le re-saisir [0-9] :"
    starting_number=""
    while [[ ! $starting_number =~ ^[0-9]+$ ]]
    do
      read starting_number
    done
  fi
fi
#//////////////////////////////////////////////////////////////////////////////////////////////////////
#///////////////////////////|Boucle commande useradd avec options|/////////////////////////////////////
#//////////////////////////////////////////////////////////////////////////////////////////////////////
echo "Traitement en cours..."
echo "" >> create_user.log
echo "" >> create_user.log
total_user=$(( $starting_number + $number_of_user ))
compteur=$starting_number
succes=0
echecs=0
while [ $compteur -lt $total_user ]
do
  now=`date`
  create_user="useradd -p 'PsttA3IFcWbiA' -s /bin/bash -m $user_basename-$compteur" #mot de passe '0000' hashé avec la fonction crypt()
  eval "$create_user"
  if [ $? -eq 0 ];
  then
    echo "$now -> $user_basename-$compteur créé avec succès !" >> creatuser.log
    let "succes++"
  else
    echo "$now -> ERREURE $user_basename-$compteur non créé !" >> creatuser.log
    let "echecs++"
  fi
  let "compteur++"
done
echo "Script terminé avec $succes succès et $echecs echecs !"
echo "Le mot de passe de chaque utilisateur est : 0000"
echo "Retrouvez les logs dans le fichier 'creatuser.log'"
