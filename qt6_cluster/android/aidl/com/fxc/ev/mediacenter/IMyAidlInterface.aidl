package com.fxc.ev.mediacenter;
// Declare any non-default types here with import statements
import com.fxc.ev.mediacenter.datastruct.MediaItem;
import com.fxc.ev.mediacenter.IDataChangeListener;

interface IMyAidlInterface {
               MediaItem getMediaItem();
               long getCurrentProgress();
               boolean getCurrentState();
               void NextSong();
               void PreviousSong();
               void PlayToPause();
               void PauseToPlay();
               void StartPlay(int device_Type,String StoragePath,int media_Type,int position);
   void registerSetupNotification(IDataChangeListener listener);
   void unRegisterSetupNotification(IDataChangeListener listener);
}
