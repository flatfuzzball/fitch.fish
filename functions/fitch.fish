function fitch -d "Fish plugin manager"

# DO NOT run in $__fish_config_dir, installation will fail.

  argparse g/get d/del  -- $argv
  or return


  if set -ql _flag_get
    # fetch the plugin from github
    git clone https://github.com/$argv

    # really shitty code moving around and deleting directories as a hacky way to get the correct files to the correct places

    mkdir $__fish_config_dir/tmp
    mv $__fish_config_dir/functions/ $__fish_config_dir/tmp
    mv (string split -f2  "/" $argv)/functions $__fish_config_dir
    set -l funcs (ls $__fish_config_dir/functions)
    mv $__fish_config_dir/tmp/ $__fish_config_dir/functions
    rm -rf $__fish_config_dir/tmp
    cp -r $__fish_config_dir/functions/tmp/functions $__fish_config_dir/
    rm -rf $__fish_config_dir/functions/tmp

    # and again for completions

    mkdir $__fish_config_dir/tmp
    mv $__fish_config_dir/completions/ $__fish_config_dir/tmp
    mv (string split -f2  "/" $argv)/completions $__fish_config_dir
    set -l comps (ls $__fish_config_dir/completions)
    mv $__fish_config_dir/tmp/ $__fish_config_dir/completions
    rm -rf $__fish_config_dir/tmp
    cp -r $__fish_config_dir/completions/tmp/completions $__fish_config_dir/
    rm -rf $__fish_config_dir/completions/tmp
    rm -rf $__fish_config_dir/completions/completions

    # and finally for configs

    mkdir $__fish_config_dir/tmp
    mv $__fish_config_dir/conf.d/ $__fish_config_dir/tmp
    mv (string split -f2  "/" $argv)/conf.d $__fish_config_dir
    set -l confs (ls $__fish_config_dir/conf.d)
    mv $__fish_config_dir/tmp/ $__fish_config_dir/conf.d
    rm -rf $__fish_config_dir/tmp
    cp -r $__fish_config_dir/conf.d/tmp/conf.d $__fish_config_dir/
    rm -rf $__fish_config_dir/conf.d/tmp
    rm -rf $__fish_config_dir/conf.d/conf.d

    # removes cloned git repo

    rm -rf (string split -f2  "/" $argv)

    # appends all files to a text file for deletion

    echo $argv >> $__fish_config_dir/fitch.txt
    echo $funcs >> $__fish_config_dir/fitch.txt
    echo $comps >> $__fish_config_dir/fitch.txt
    echo $confs >> $__fish_config_dir/fitch.txt
    echo \n >> $__fish_config_dir/fitch.txt

    echo Installed plugin! You may need to restart fish for changes to take effect.

  end

  if set -ql _flag_del

    # gets line number for plugin in fitch index, goes through each folder and deletes the indexed files.

    set -l plugnum (grep -n $argv $__fish_config_dir/fitch.txt | sed 's/[^0-9]*//g')
    set -l ogpwd $pwd
    cd $__fish_config_dir/functions
    rm -rf (string split ' ' (awk NR==(math $plugnum+1) $__fish_config_dir/fitch.txt))

    cd $__fish_config_dir/completions
    rm -rf (string split ' ' (awk NR==(math $plugnum+2) $__fish_config_dir/fitch.txt))

    cd $__fish_config_dir/conf.d
    rm -rf (string split ' ' (awk NR==(math $plugnum+3) $__fish_config_dir/fitch.txt))

    cd $ogpwd

    # removes deleted plugin from index

    sed -i (math $plugnum+1)d $__fish_config_dir/fitch.txt
    sed -i (math $plugnum+2)d $__fish_config_dir/fitch.txt
    sed -i (math $plugnum+3)d $__fish_config_dir/fitch.txt
    sed -i (math $plugnum)d $__fish_config_dir/fitch.txt

    echo Removed plugin! You may need to restart fish for changes to take effect.

  end
end
