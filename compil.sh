# executer pour compilation

clear

cd /Users/mathieu/Desktop/Developer/iPhone/JBDev/Notification\ Center/SlideCenter/
#ln -s /Users/mathieu/Desktop/Developer/iPhone/JBDev/theos ./theos

make -f Makefile

mkdir -p ./layout/DEBIAN
cp ./control ./layout/DEBIAN
chmod -R 755 ./layout/DEBIAN

cp ./obj/SlideCenter.dylib ./layout/System/Library/WeeAppPlugins/SlideCenter.bundle/SlideCenter

sudo find ./ -name ".DS_Store" -depth -exec rm {} \;

export COPYFILE_DISABLE=true
export COPY_EXTENDED_ATTRIBUTES_DISABLE=true

dpkg-deb -b layout
mv ./layout.deb ./SlideCenter.deb
