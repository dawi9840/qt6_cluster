package com.foxconn;

import android.content.ComponentName;
import android.content.Context;
import android.net.Uri;
import android.support.v4.media.MediaBrowserCompat;
import android.support.v4.media.MediaMetadataCompat;
import android.support.v4.media.session.MediaControllerCompat;
import android.support.v4.media.session.MediaSessionCompat;
import android.support.v4.media.session.PlaybackStateCompat;
import android.util.Log;
import java.util.List;

public class MediaPlaybackHandler {
    private static final String TAG = "MediaPlaybackHandler";
    private static MediaBrowserCompat mMediaBrowser;
    private MediaBrowserConnectionCallback mMediaCallBack;
    private MediaPlaybackCallback mediaPlaybackCallback;
    private MediaControllerCompat mMediaController;
    private String packageName = "com.fxc.ev.mediacenter";
    private String className = "com.fxc.ev.mediacenter.service.LocalMediaBrowserService";

    public void initializeMediaBrowser(Context context) {
        if (mMediaCallBack == null) {
            mMediaCallBack = new MediaBrowserConnectionCallback(context);
        }
        if (mMediaBrowser == null) {
            mMediaBrowser = new MediaBrowserCompat(
                    context.getApplicationContext(),
                    new ComponentName(packageName, className),
                    mMediaCallBack,
                    null);
        }
        if (!mMediaBrowser.isConnected()) {
            mMediaBrowser.connect();
        }
    }

    public void reInitMediaBrowser(Context context){
        if (mMediaCallBack != null) {
            mMediaCallBack = null;
        }
        if (mMediaBrowser != null) {
            mMediaBrowser = null;
        }
        mMediaCallBack = new MediaBrowserConnectionCallback(context);
        mMediaBrowser = new MediaBrowserCompat(
                context.getApplicationContext(),
                new ComponentName(packageName, className),
                mMediaCallBack,
                null);
        if (!mMediaBrowser.isConnected()) {
            mMediaBrowser.connect();
        }
    }

    public void setMediaPlaybackCallback(MediaPlaybackCallback callback) {
        this.mediaPlaybackCallback = callback;
    }

    private class MediaBrowserConnectionCallback extends MediaBrowserCompat.ConnectionCallback {
        private final Context mContext;
        public MediaBrowserConnectionCallback(Context context) {
            this.mContext = context.getApplicationContext();
        }
        @Override
        public void onConnected() {
            if (mMediaBrowser.isConnected()) {
                mMediaController = new MediaControllerCompat(mContext, mMediaBrowser.getSessionToken());
                mMediaController.registerCallback(new MediaControllerCompat.Callback() {
                    @Override
                    public void onMetadataChanged(MediaMetadataCompat metadata) {
                        if (metadata != null) {
                            String artistAndAlbum = metadata.getString(MediaMetadataCompat.METADATA_KEY_ALBUM) + "-" + metadata.getString(MediaMetadataCompat.METADATA_KEY_ARTIST);
                            String songName = metadata.getString(MediaMetadataCompat.METADATA_KEY_TITLE);
                            long totalTime = metadata.getLong(MediaMetadataCompat.METADATA_KEY_DURATION);
                            Uri albumPhoto = metadata.getDescription().getIconUri();
                            if (mediaPlaybackCallback != null) {
                                mediaPlaybackCallback.onUpdateUI(songName, artistAndAlbum, totalTime, albumPhoto);
                            }
                        }
                    }

                    @Override
                    public void onPlaybackStateChanged(PlaybackStateCompat playbackState) {
                        //Log.d(TAG, "MediaBrowser_playbackState: " + playbackState.getState());
                        if (playbackState != null) {
                            if (playbackState.getState() == PlaybackStateCompat.STATE_PLAYING) {
                                long currentTime = playbackState.getPosition();
                                if (mediaPlaybackCallback != null) {
                                    mediaPlaybackCallback.onCurrentTimeChanged(currentTime);
                                }
                            } else if (playbackState.getState() == PlaybackStateCompat.STATE_STOPPED
                                        || playbackState.getState() == PlaybackStateCompat.STATE_NONE) {
                                if (mediaPlaybackCallback != null) {
                                    mediaPlaybackCallback.onSessionDestroyed();
                                }
                            }
                        }
                    }

                    @Override
                    public void onSessionDestroyed() {
                        super.onSessionDestroyed();
                        Log.d(TAG, "MediaBrowser_status: " + "onSessionDestroyed");
                        if (mediaPlaybackCallback != null) {
                            mediaPlaybackCallback.onSessionDestroyed();
                        }
                    }

                    @Override
                    public void onQueueChanged(List<MediaSessionCompat.QueueItem> queue) {
                        super.onQueueChanged(queue);
                        Log.d(TAG, "MediaBrowser_status: " + "onQueueChanged");
                    }
                });
                Log.d(TAG, "MediaBrowser_status: " + "Connect success!");
            }
        }
        @Override
        public void onConnectionFailed() {
            super.onConnectionFailed();
            Log.i(TAG, "MediaBrowser_status: Connect failed!");
        }
    }

    public interface MediaPlaybackCallback {
        void onUpdateUI(String songName, String artistAndAlbum, long totalTime, Uri albumPhoto);
        void onCurrentTimeChanged(long currentTime);
        void onSessionDestroyed();
    }
}
