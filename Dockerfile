FROM kasmweb/core-ubuntu-jammy:1.16.0
USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
ENV INST_SCRIPTS $STARTUPDIR/install
WORKDIR $HOME

######### Customize Container Here ###########


COPY custom_startup.sh $STARTUPDIR/custom_startup.sh
RUN chmod +x /dockerstartup/custom_startup.sh && apt update ; apt install -y libxcb-* libxkbcommon-x11-0 python3-pyqt5 python3-pip python3-pyqt5.qtsvg && pip install orange3 && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Update the desktop environment to be optimized for a single application
RUN cp $HOME/.config/xfce4/xfconf/single-application-xfce-perchannel-xml/* $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
RUN cp /usr/share/backgrounds/bg_kasm.png /usr/share/backgrounds/bg_default.png
RUN apt-get remove -y xfce4-panel

# Security modifications
COPY ./single_app_security.sh $INST_SCRIPTS/misc/
RUN  bash $INST_SCRIPTS/misc/single_app_security.sh -t && rm -rf $INST_SCRIPTS/misc/


######### End Customizations ###########

RUN chown 1000:0 $HOME
RUN $STARTUPDIR/set_user_permission.sh $HOME

ENV HOME /home/kasm-user
WORKDIR $HOME
RUN mkdir -p $HOME && chown -R 1000:0 $HOME

USER 1000
