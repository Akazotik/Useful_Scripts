date=$(date +"%d-%m-%Y")
hostname=$(hostname)
auditor=$(whoami)
id=$(id -u)
dir_data=/home/$auditor/$hostname'_'$date
mkdir $dir_data

echo "Дата: $date"
echo "Сервер: $hostname" 
echo "Проверяющий: $auditor" 
echo "ID: $id"

echo -e "\n****НАСТРОЙКИ ПАРОЛЬНОЙ ПОЛИТИКИ****" 

echo -e "\n****Проверка максимального срока пароля и срока предупреждения об окончании****\n" 
cat /etc/login.defs > "$dir_data/$date-$hostname-login.defs.txt"
if grep -q -E "PASS_MAX_DAYS.+?60" /etc/login.defs
then
echo "Максимальный срок пароля задан верно - $date-$hostname-login.defs.txt" 
else 
echo "Максимальный срок пароля задан неверно - $date-$hostname-login.defs.txt" 
fi
if grep -q -E "PASS_WARN_AGE.+?14" /etc/login.defs
then
echo "Срок предупреждения об окончании пароля задан верно - $date-$hostname-login.defs.txt" 
else 
echo "Срок предупреждения об окончании пароля задан верно - $date-$hostname-login.defs.txt" 
fi

echo -e "\n****Проверка минимального срока пароля****\n" 

if grep -q -E "PASS_MIN_DAYS.+?1" /etc/login.defs
then
echo "Минимальный срок пароля задан верно - $date-$hostname-login.defs.txt" 
else 
echo "Минимальный срок пароля задан неверно - $date-$hostname-login.defs.txt" 
fi

echo -e "\n****Проверка сложности пароля****\n" 

cat /etc/pam.d/common-password > "$dir_data/$date-$hostname-common-password.txt"
if grep -q "ucredit=-1" /etc/pam.d/common-password
then
echo "Параметр ucredit задан верно - $date-$hostname-common-password.txt" 
else 
echo "Параметр ucredit задан неверно - $date-$hostname-common-password.txt" 
fi
if grep -q "lcredit=-1" /etc/pam.d/common-password
then
echo "Параметр lcredit задан верно - $date-$hostname-common-password.txt" 
else 
echo "Параметр lcredit задан неверно - $date-$hostname-common-password.txt" 
fi
if grep -q "dcredit=-1" /etc/pam.d/common-password
then
echo "Параметр dcredit задан верно - $date-$hostname-common-password.txt" 
else 
echo "Параметр dcredit задан неверно - $date-$hostname-common-password.txt" 
fi
if grep -q "ocredit=-1" /etc/pam.d/common-password
then
echo "Параметр ocredit задан верно - $date-$hostname-common-password.txt" 
else 
echo "Параметр ocredit задан неверно - $date-$hostname-common-password.txt" 
fi

echo -e "\n****НАСТРОЙКА БЛОКИРОВКИ УЗ****" 

echo -e "\n****Проверка количества неудачных попыток для блокировки УЗ****\n" 

cat /etc/pam.d/common-auth > "$dir_data/$date-$hostname-common-auth.txt"
if grep -q "per_user deny=10" /etc/pam.d/common-auth
then
echo "Количество попыток задано верно - $date-$hostname-common-auth.txt" 
else 
echo "Количество попыток задано неверно - $date-$hostname-common-auth.txt" 
fi

echo -e "\n****Проверка количества новых уникальных паролей****\n" 

if grep -q "remember=24" /etc/pam.d/common-password
then
echo "Количество уникальных паролей задано верно - $date-$hostname-common-password.txt" 
else 
echo "Количество уникальных паролей задано неверно - $date-$hostname-common-password.txt" 
fi

echo -e "\n****Проверка блокировки пользователя на 30 минут после ввода неправильного пароля****\n" 

if grep -q "unlock_time=1800" /etc/pam.d/common-auth
then
echo "Срок блокировки задан верно - $date-$hostname-common-auth.txt" 
else 
echo "Срок блокировки задан неверно - $date-$hostname-common-auth.txt" 
fi

echo -e "\n****НАСТРОЙКА ПАРАМЕТРОВ БЕЗОПАСНОСТИ****" 

echo -e "\n****Проверка ограничения доступа к консоли для пользователей****\n" 

systemctl is-enabled astra-console-lock > $dir_data/astra-console.txt
if grep -q "enabled" $dir_data/astra-console.txt
then
echo "Доступ к консоли для пользователей ограничен" 
else
echo "Доступ к консоли для пользователей не ограничен" 
fi

echo -e "\n****Проверка блокировки системных УЗ****\n" 

cat /etc/passwd > "$dir_data/$date-$hostname-etc-passwd.txt"
echo -e "daemon
mail
news
nobody
wwwrun
sshd
lp
uucp" > $dir_data/NameBlock.txt
for i in $(cat $dir_data/NameBlock.txt)
do 
   if grep -q -E "^$i.+?nologin|^$i.+?false" /etc/passwd 
   then
   echo "Учетная запись $i заблокирована - $date-$hostname-etc-passwd.txt" 
   else
   echo "Учетная запись $i не заблокирована - $date-$hostname-etc-passwd.txt" 
   fi 
done 

echo -e "\n****Проверка настройки маски режима киоска****\n" 

cat /parsecfs/mode_mask > "$dir_data/$date-$hostname-mode_mask.txt" 
if grep -q "0000" /parsecfs/mode_mask
then 
echo "Маска задана неверно - $date-$hostname-mode_mask.txt" 
else
echo "Маска задана верно - $date-$hostname-mode_mask.txt" 
fi

echo -e "\n****Проверка системных ограничений для пользователей****\n" 

systemctl is-enabled astra-ulimits-control > $dir_data/astra-ulimits.txt
if grep -q "enabled" $dir_data/astra-ulimits.txt
then
echo "Системные ограничения включены" 
else
echo "Системные ограничения выключены" 
fi

echo -e "\n****Проверка запрета на использование клавищи SysRq****\n" 

cat /etc/sysctl.conf > "$dir_data/$date-$hostname-sysctl.txt"
if grep -q "kernel.sysrq=0" /etc/sysctl.conf
then 
echo "Использование клавищи SysRq запрещено - $date-$hostname-sysctl.txt" 
else
echo "Использование клавищи SysRq не запрещено - $date-$hostname-sysctl.txt" 
fi

echo -e "\n****Проверка запрета на использование модулей Python****\n"

find /usr/lib/python* -type f -name "_ctype*" > $dir_data/python.txt
for i in $(cat $dir_data/python.txt)
do
ls -l $i > $dir_data/pythonls.txt
if grep -q -E "^-rw-r-----.+?root.+?$i.+?$" ./pythonls.txt
then
echo "$i - Запрет на использование модулей Python - включен"
else
echo "$i - Запрет на использование модулей Python - выключен"
fi
done

echo -e "\n****Проверка параметров безопасности для SSH****\n"

cat /etc/ssh/sshd_config > "$dir_data/$date-$hostname-sshd-config.txt"

if grep -q -E "^Protocol.+?2" /etc/ssh/sshd_config
then
echo "Параметр Protocol задан верно"
else
echo "Параметр Protocol задан неверно"
fi
if grep -q -E "^LoginGraceTime.+?3m" /etc/ssh/sshd_config
then
echo "Параметр LoginGraceTime задан верно"
else
echo "Параметр LoginGraceTime задан неверно"
fi
if grep -q -E "^PermitRootLogin.+?no" /etc/ssh/sshd_config
then
echo "Параметр PermitRootLogin задан верно"
else
echo "Параметр PermitRootLogin задан неверно"
fi
if grep -q -E "^IgnoreRhosts.+?yes" /etc/ssh/sshd_config
then
echo "Параметр IgnoreRhosts задан верно"
else
echo "Параметр IgnoreRhosts задан неверно"
fi
if grep -q -E "^MaxAuthTries.+?6" /etc/ssh/sshd_config
then
echo "Параметр MaxAuthTries задан верно"
else
echo "Параметр MaxAuthTries задан неверно"
fi
if grep -q -E "^PermitEmptyPasswords.+?no" /etc/ssh/sshd_config
then
echo "Параметр PermitEmptyPasswords задан верно"
else
echo "Параметр PermitEmptyPasswords задан неверно"
fi
if grep -q -E "^UsePAM.+?yes" /etc/ssh/sshd_config
then
echo "Параметр UsePAM задан верно"
else
echo "Параметр UsePAM задан неверно"
fi
if grep -q -E "^TCPKeepAlive.+?yes" /etc/ssh/sshd_config
then
echo "Параметр TCPKeepAlive задан верно"
else
echo "Параметр TCPKeepAlive задан неверно"
fi
if grep -q -E "^X11Forwarding.+?no" /etc/ssh/sshd_config
then
echo "Параметр X11Forwarding задан верно"
else
echo "Параметр X11Forwarding задан неверно"
fi