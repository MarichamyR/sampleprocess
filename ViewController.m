//
//  ViewController.h
//  Getting Started
//
//  Created by Jeff Swartz on 11/19/14.
//  Copyright (c) 2014 TokBox, Inc. All rights reserved.

#import "ViewController.h"
#import <OpenTok/OpenTok.h>
#import "OTKBasicVideoRender.h"
#import "UserNotificationData.h"
static pthread_mutex_t outputAudioFileLock;


@interface ViewController ()
{
    //    OTSession* _session;
    //    OTPublisher* _publisher;
    //    OTSubscriber* _subscriber;
    
    OTKBasicVideoRender *_renderer;
    NSString* _archiveId;
    NSString* _kApiKey;
    NSString* _kSessionId;
    NSString* _kToken;
     int disbalecamera;
    NSTimer *timer;
    int seconds;
    
 //   UIView *myView;
    
    
}


@end
@implementation ViewController @synthesize sessiondIDandTokenResponse;

static double widgetHeight = 175;
static double widgetWidth = 175;




static NSString* const ApiKey =@"45736592";
static NSString* const SessionId =@"1_MX40NTczNjU5Mn5-MTQ4MTg2OTc2MjA0Nn40R2NlZEZRTmovZFRoNG1VWWs5NHZVdUR-fg";
static NSString* const Token=@"T1==cGFydG5lcl9pZD00NTczNjU5MiZzaWc9M2Q2ZDU4MmVmMjBkYzAzYTAzMWRjNjkxZGEyZTNkM2IzNGQyNDM2NjpzZXNzaW9uX2lkPTFfTVg0ME5UY3pOalU1TW41LU1UUTRNVGcyT1RjMk1qQTBObjQwUjJObFpFWlJUbW92WkZSb05HMVZXV3M1TkhaVmRVUi1mZyZjcmVhdGVfdGltZT0xNDgxODY5Nzc5Jm5vbmNlPTAuMDM3NjA2NjI5NDQyNzUzNSZyb2xlPXB1Ymxpc2hlciZleHBpcmVfdGltZT0xNDg0NDYxNzc5";


static bool subscribeToSelf = NO;



UserNotificationData *notifyData;
#pragma mark - View lifecycle


//- (void)getSessionCredentials
//{
//    NSString* urlPath =@"https://graph.facebook.com/oauth/access_token?apiKey=123456&token=T1==cGFydG5lcl9pZD00jg=&sessionId=2_MX40NDQ0MzEyMn5-fn4";
//        urlPath = [urlPath stringByAppendingString:@"/session"];
//        NSURL *url = [NSURL URLWithString: urlPath];
//        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
//        [request setHTTPMethod: @"GET"];
//
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//                if (error){
//                        NSLog(@"Error,%@, URL: %@", [error localizedDescription],urlPath);
//                    }
//                else{
//                        NSDictionary *roomInfo = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//
//                        _apiKey = [[roomInfo objectForKey:@"error"]objectForKey:@"code"];
//                        kToken = [[roomInfo objectForKey:@"error"]objectForKey:@"fbtrace_id"];
//                        kSessionId = [[roomInfo objectForKey:@"error"]objectForKey:@"type"];
//
//                        if(!_apiKey || !kToken || !kSessionId) {
//                                NSLog(@"Error invalid response from server, URL: %@",urlPath);
//                           } else {
//                                    [self doConnect];
//                                }
//                    }
//            }];
//}
//


//- (void)getSessionIdAndToken{
//    //get session ID and token from server
//
//    //set up request to go to the url
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"www.google.com"] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
//
//    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//
//    //if we get a connection, do something, else, throw and error
//
//    if(connection){
//        //connect
//        NSLog(@"getting session id and token");
//
//    } else {
//        NSLog(@"error getting session id and token");
//    }
//
//}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"receiving session id and token data");
    sessiondIDandTokenResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"session id and token are %@", sessiondIDandTokenResponse);
    
    NSLog(@"parsing session id and token");
    
    NSArray *components = [sessiondIDandTokenResponse componentsSeparatedByString:@":"];
    //    kSessionId = [components objectAtIndex:0];
    //    kToken = [components objectAtIndex:1];
    //
    
    //NSLog(@"token is %@", kToken);
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
    connection = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return NO;
    } else {
        return YES;
    }
}

- (void)updateSubscriber {
    for (NSString* streamId in _session.streams) {
        OTStream* stream = [_session.streams valueForKey:streamId];
        if (![stream.connection.connectionId isEqualToString: _session.connection.connectionId]) {
            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
            break;
        }
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //    AVAudioSession *session =   [AVAudioSession sharedInstance];
    //    NSError *error;
    //    [_btnSpeaker setImage:[UIImage imageNamed:@"High Volume-50 (1).png"] forState:UIControlStateNormal];
    //    [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
    //    _btnSpeaker.tag=000;
    
    OTDefaultAudioDeviceWithVolumeControl  *audioDevice =[OTDefaultAudioDeviceWithVolumeControl sharedInstance];
    [OTAudioDeviceManager setAudioDevice:audioDevice];
    
    [self initNavBar];
    
    
    _btnSpeaker.tag=111;
    
    //OTError *error;
    _session = [[OTSession alloc] initWithApiKey:ApiKey
                                       sessionId:SessionId
                                        delegate:self];
    [_session connectWithToken:Token error:nil];
    
    [self doConnect];
    
    
    
    
    //    if (error) {
    //        NSLog(@"connect failed with error: (%@)", error);
    //    }
    //   else{
    //[self doConnect];
    // }
    // [self getSessionCredentials];
    // [self getSessionIdAndToken];
    
    // _session=[[OTSession alloc] initWithApiKey:kApiKey sessionId:kSessionId delegate:self];
    
    disbalecamera=0;
    _timertoShow = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-55, self.view.frame.origin.y+110,55,20)];
    _timertoShow.backgroundColor =[UIColor colorWithRed:138.0f/255.0f green:155.0f/255.0f blue:184.0f/255.0f alpha:1.0f];
    _timertoShow.layer.cornerRadius=2.0f;
    _timertoShow.clipsToBounds=YES;
    [_timertoShow setFont:[UIFont systemFontOfSize:10]];
    _timertoShow.textAlignment = NSTextAlignmentCenter;
    
    _timertoShow.textColor=[UIColor whiteColor];
    _timertoShow.text = @"Time";
    
    
    [self setUpPubNubChatApi];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(leavingBackgroundMode:)
     name:UIApplicationDidBecomeActiveNotification
     object:nil];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                             target:self
                                           selector:@selector(subtractTime)
                                           userInfo:nil
                                            repeats:YES];
    

    
}

- (void)subtractTime
{
    seconds++;
    
    // _durationofTime.text = [NSString stringWithFormat:@"Time: %i",seconds];
    _timertoShow.text=[NSString stringWithFormat:@"Time: %i",seconds];
    
    
}


-(void)initNavBar
{
    
    
    self.navigationItem.title=NSLocalizedString(@"WISPhone",nil);
    
    
    UIBarButtonItem *bckBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow_left"]
                                                               style:UIBarButtonItemStylePlain
                                                              target:self action:@selector(backButton)];
    [bckBtn setTintColor:[UIColor whiteColor]];
    
    [self.navigationItem setLeftBarButtonItem:bckBtn animated:YES];
    
}

#pragma mark - OpenTok methods

- (void)doConnect
{
    _session = [[OTSession alloc] initWithApiKey:ApiKey
                                       sessionId:SessionId
                                        delegate:self];
    OTError *error=nil;
    [_session connectWithToken:Token error:&error];
    if (error)
    {
        [self showAlert:[error localizedDescription]];
    }
}

- (void)doPublish
{
    _publisher.cameraPosition= AVCaptureDevicePositionBack;
    [_publisherAudioBtn addTarget:self
                           action:@selector(togglePublisherMic)
     
                 forControlEvents:UIControlEventTouchUpInside];
    _swapCameraBtn.hidden = NO;
    
    [_renderer.renderView setFrame:CGRectMake(0, 0, self.view.bounds.size.width,
                                              self.view.bounds.size.height)];
    
    [self.view addSubview:_renderer.renderView];
    
    OTError *error=nil;
    _publisher = [[OTPublisher alloc] initWithDelegate:self name:@"Video" cameraResolution:OTCameraCaptureResolutionHigh cameraFrameRate:OTCameraCaptureFrameRate30FPS];
    
    _renderer = [[OTKBasicVideoRender alloc] init];
    
    _publisher.videoRender = _renderer;
    
    
    _publisher =
    [[OTPublisher alloc] initWithDelegate:self
                                     name:[[UIDevice currentDevice] name]];
    
    [_session publish:_publisher error:nil];
    // _publisher.videoCapture = [[OTKBasicVideoCapturer alloc] init];
    
    if (error)
    {
        NSLog(@"Unable to publish (%@)",
              error.localizedDescription);
    }
    
    
    // [_publisher.view setFrame:CGRectMake(0, 0, _publisherView.bounds.size.width,
    //                                     _publisherView.bounds.size.height)];
    [_publisher.view setFrame:CGRectMake(150, 330, widgetWidth, widgetHeight)];
    _publisherAudioBtn.hidden = NO;
    
    [_swapCameraBtn addTarget:self
                       action:@selector(swapCamera)
             forControlEvents:UIControlEventTouchUpInside];
    
    //    _publisher.videoCapture = [[OTKBasicVideoCapturer alloc] initWithPreset:AVCaptureSessionPreset352x288
    //                                                        andDesiredFrameRate:30];
    //    [self.view addSubview:_publisher.view];
    _SwitchCameraBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    [_SwitchCameraBtn setFrame:CGRectMake(self.view.frame.size.width-40,self.view.frame.origin.y+70,35,35)];
    _SwitchCameraBtn.backgroundColor = [UIColor colorWithRed:138.0f/255.0f green:155.0f/255.0f blue:184.0f/255.0f alpha:1.0f];
    UIImage *buttonImage = [UIImage imageNamed:@"switchCamera"];
    _SwitchCameraBtn.layer.cornerRadius=2.0f;
    _SwitchCameraBtn.clipsToBounds=YES;
    
    [_SwitchCameraBtn setImage:buttonImage forState:UIControlStateNormal];
    
    [_SwitchCameraBtn addTarget:self
                         action:@selector(SwitchCamera)
               forControlEvents:UIControlEventTouchUpInside];
}


-(void)SwitchCamera
{
    NSLog(@"%ld the camera postion",(long)_publisher.cameraPosition);
    if (_publisher.cameraPosition == AVCaptureDevicePositionFront) {
        _publisher.cameraPosition = AVCaptureDevicePositionBack;
    } else {
        _publisher.cameraPosition = AVCaptureDevicePositionFront;
    }
}



- (void)sessionDidConnect:(OTSession*)session
{
    // NSLog(@"sessionDidConnect (%@)", session.sessionId);
    [self doPublish];
}
- (void)subscriberVideoDataReceived:(OTSubscriber *)subscriber
{
    
    [subscriber.view setFrame:CGRectMake(0, 0,self.view.bounds.size.width ,510)];
    [subscriber.view addSubview:_SwitchCameraBtn];
    [subscriber.view addSubview:_timertoShow];
    [self.view addSubview:subscriber.view];
    [subscriber.view addSubview:_publisher.view];
    
}

- (void)publisher:(OTPublisherKit *)publisher
    streamCreated:(OTStream *)stream
{
    NSLog(@"Now publishing.");
  //  [self subtractTime];
    if (nil == _subscriber && subscribeToSelf)
    {
        [self doSubscribe:stream];
    }
}

- (void)publisher:(OTPublisherKit*)publisher
  streamDestroyed:(OTStream *)stream
{
    Name=@"Session";
    NSLog(@"session streamDestroyed (%@)", stream.streamId);
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
    [self cleanupPublisher];
}

- (void)cleanupPublisher {
    [_publisher.view removeFromSuperview];
    _publisher = nil;
}

- (void)session:(OTSession*)session
  streamCreated:(OTStream *)stream
{
    NSLog(@"session streamCreated (%@)", stream.streamId);
    
    if (nil == _subscriber)
    {
        [self doSubscribe:stream];
    }
}

- (void)doSubscribe:(OTStream*)stream
{
    _subscriber = [[OTSubscriber alloc] initWithStream:stream
                                              delegate:self];
    OTError *error = nil;
    [_session subscribe:_subscriber error:&error];
    if (error)
    {
        NSLog(@"Unable to publish (%@)",
              error.localizedDescription);
    }
}


- (void)subscriberDidConnectToStream:(OTSubscriber*)subscriber
{
    
    NSLog(@"subscriberDidConnectToStream (%@)", subscriber.stream.connection.connectionId);
    [subscriber.view setFrame:CGRectMake(0, widgetHeight, widgetWidth, widgetHeight)];
    
    [self.view addSubview:subscriber.view];
    _subscriberAudioBtn.hidden = NO;
    [_subscriberAudioBtn addTarget:self
                            action:@selector(toggleSubscriberAudio)
                  forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)session:(OTSession*)session
streamDestroyed:(OTStream *)stream
{
    Name=@"Session";
    NSLog(@"session streamDestroyed (%@)", stream.streamId);
    if ([_subscriber.stream.streamId isEqualToString:stream.streamId])
    {
        [self cleanupSubscriber];
    }
}


- (void)  session:(OTSession *)session connectionCreated:(OTConnection *)connection
{
    NSLog(@"session connectionCreated (%@)", connection.connectionId);
}
- (void)cleanupSubscriber {
    [_subscriber.view removeFromSuperview];
    _subscriber = nil;
}

- (void)    session:(OTSession *)session
connectionDestroyed:(OTConnection *)connection
{
    Name=@"Session";
    NSLog(@"session connectionDestroyed (%@)", connection.connectionId);
    if ([_subscriber.stream.connection.connectionId
         isEqualToString:connection.connectionId])
    {
        [self cleanupSubscriber];
    }
}

-(void)togglePublisherMic
{
    _publisher.publishAudio = !_publisher.publishAudio;
    UIImage *buttonImage;
    if (_publisher.publishAudio) {
        buttonImage = [UIImage imageNamed: @"mic-24.png"];
    } else {
        buttonImage = [UIImage imageNamed: @"mic_muted-24.png"];
    }
    [_publisherAudioBtn setImage:buttonImage forState:UIControlStateNormal];
}

-(void)toggleSubscriberAudio
{
    _subscriber.subscribeToAudio = !_subscriber.subscribeToAudio;
    UIImage *buttonImage;
    if (_subscriber.subscribeToAudio) {
        buttonImage = [UIImage imageNamed: @"Subscriber-Speaker-35.png"];
    } else {
        buttonImage = [UIImage imageNamed: @"Subscriber-Speaker-Mute-35.png"];
    }
    [_subscriberAudioBtn setImage:buttonImage forState:UIControlStateNormal];
}

-(void)swapCamera
{
//     NSLog(@"%ld",(long)_publisher.cameraPosition);
//    if (_publisher.cameraPosition == AVCaptureDevicePositionFront) {
//        _publisher.cameraPosition = AVCaptureDevicePositionBack;
//    } else {
//        _publisher.cameraPosition = AVCaptureDevicePositionFront;
//    }
    
    
    
    
    if (disbalecamera == 0) {
        _publisher.publishVideo=NO;
        _publisher.publishAudio=YES;
        
        disbalecamera=1;
    }
    else{
        _publisher.publishVideo=YES;
        _publisher.publishAudio=YES;
         disbalecamera=0;
    }
    
}

- (void)     session:(OTSession*)session
archiveStartedWithId:(NSString *)archiveId
                name:(NSString *)name
{
    NSLog(@"session archiving started with id:%@ name:%@", archiveId, name);
    archiveId = archiveId;
    //    _archivingIndicatorImg.hidden = NO;
    //    [_archiveControlBtn setTitle: @"Stop recording" forState:UIControlStateNormal];
    //    _archiveControlBtn.hidden = NO;
    //    [_archiveControlBtn addTarget:self
    //                           action:@selector(stopArchive)
    //                 forControlEvents:UIControlEventTouchUpInside];
}

- (void)     session:(OTSession*)session
archiveStoppedWithId:(NSString *)archiveId
{
    NSLog(@"session archiving stopped with id:%@", archiveId);
    //    _archivingIndicatorImg.hidden = YES;
    //    [_archiveControlBtn setTitle: @"View archive" forState:UIControlStateNormal];
    //    _archiveControlBtn.hidden = NO;
    //    [_archiveControlBtn addTarget:self
    //                           action:@selector(loadArchivePlaybackInBrowser)
    //                forControlEvents:UIControlEventTouchUpInside];
}


- (void) sendChatMessage
{
    OTError* error = nil;
    //  [_session signalWithType:@"chat"
    //                      string:_chatInputTextField.text
    //                  connection:nil error:&error];
    if (error) {
        NSLog(@"Signal error: %@", error);
    } else {
        //     NSLog(@"Signal sent: %@", _chatInputTextField.text);
    }
    //   _chatTextInputView.text = @"";
}

- (void)session:(OTSession*)session receivedSignalType:(NSString*)type fromConnection:(OTConnection*)connection withString:(NSString*)string {
    NSLog(@"Received signal %@", string);
    Boolean fromSelf = NO;
    if ([connection.connectionId isEqualToString:session.connection.connectionId]) {
        fromSelf = YES;
    }
    [self logSignalString:string fromSef:string];
}

-(void)logSignalString:(NSString *)str fromSef:(NSString*)strValue{
    
}

- (void)sessionDidDisconnect:(OTSession*)session
{
    NSString* alertMessage = [NSString stringWithFormat:@"Session disconnected: (%@)", session.sessionId];
    NSLog(@"sessionDidDisconnect (%@)", alertMessage);
    [self showAlert:alertMessage];
}


//- (void)session:(OTSession*)mySession didReceiveStream:(OTStream*)stream
//{
//    NSLog(@"session didReceiveStream (%@)", stream.streamId);
//
//    // See the declaration of subscribeToSelf above.
//    if ( (subscribeToSelf && [stream.connection.connectionId isEqualToString: _session.connection.connectionId])
//        ||
//        (!subscribeToSelf && ![stream.connection.connectionId isEqualToString: _session.connection.connectionId])
//        ) {
//        if (!_subscriber) {
//            _subscriber = [[OTSubscriber alloc] initWithStream:stream delegate:self];
//        }
//    }
//}
//
//- (void)session:(OTSession*)session didDropStream:(OTStream*)stream{
//    NSLog(@"session didDropStream (%@)", stream.streamId);
//    NSLog(@"_subscriber.stream.streamId (%@)", _subscriber.stream.streamId);
//    if (!subscribeToSelf
//        && _subscriber
//        && [_subscriber.stream.streamId isEqualToString: stream.streamId])
//    {
//        _subscriber = nil;
//        [self updateSubscriber];
//    }
//}
//
//
//
- (void)publisher:(OTPublisher*)publisher didFailWithError:(OTError*) error {
    NSLog(@"publisher didFailWithError %@", error);
    [self showAlert:[NSString stringWithFormat:@"There was an error publishing."]];
    [self cleanupPublisher];
}

- (void)subscriber:(OTSubscriber*)subscriber didFailWithError:(OTError*)error
{
    NSLog(@"subscriber %@ didFailWithError %@", subscriber.stream.streamId, error);
    [self showAlert:[NSString stringWithFormat:@"There was an error subscribing to stream %@", subscriber.stream.streamId]];
}

- (void)session:(OTSession*)session didFailWithError:(OTError*)error {
    NSLog(@"sessionDidFail");
    [self showAlert:[NSString stringWithFormat:@"There was an error connecting to session %@", session.sessionId]];
}


- (void)showAlert:(NSString*)string {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to connect to user"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    Name=@"Session";
    
}

-(BOOL)shouldAutorotate
{ return NO;
}


-(IBAction)SpeakerBtn:(id)sender
{
    AVAudioSession *session =   [AVAudioSession sharedInstance];
    NSError *error;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [session setMode:AVAudioSessionModeVoiceChat error:&error];
    if (_btnSpeaker.tag==111) // Enable speaker
    {
        [_btnSpeaker setImage:[UIImage imageNamed:@"No Audio-50.png"] forState:UIControlStateNormal];
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&error];
        _btnSpeaker.tag=000;
        
    }
    else // Disable speaker
    {
        [_btnSpeaker setImage:[UIImage imageNamed:@"High Volume-50 (1).png"] forState:UIControlStateNormal];
        [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error];
        _btnSpeaker.tag=111;
        
    }
    [session setActive:YES error:&error];
}


-(IBAction)PhoneEndBtn:(id)sender
{
    if (![Name isEqualToString:@"Session"]) {
        if ([_currentID isEqualToString:_senderId]) {
            notifyData.isAvailOnetoOne=FALSE;
            [self.view makeToast:NSLocalizedString(@"Call Disconnected",nil)];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self stopTimer];
        }
        else{
            
            if ([Name isEqualToString:@"Session"]) {
                notifyData.isAvailOnetoOne=FALSE;
                [self.navigationController popToRootViewControllerAnimated:YES];
                 [self stopTimer];
            }else{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [self.view makeToast:NSLocalizedString(@"Call Disconnected",nil)];
                NSDictionary *extras = @{@"senderID":_senderId,@"ReceiverID":_receiverId,@"senderName":_senderName,@"ReceiverName":_receiverName,@"Name":@"Video Call Disconnected",@"currentChenal":__currentChennalViewID};
                self.msgToSend = [[SOMessage alloc] init];
                [self.msgToSend isEqual:@""];
                [self PubNubPublishMessage:@"Call Rejected" extras:extras somessage:self.msgToSend];
                 [self stopTimer];
            }
        }
    }
    else{
        if ([_currentID isEqualToString:_senderId]) {
            notifyData.isAvailOnetoOne=FALSE;
            [self.navigationController popToRootViewControllerAnimated:YES];
             [self stopTimer];
        }else{
            notifyData.isAvailOnetoOne=FALSE;
            [self.navigationController popToRootViewControllerAnimated:YES];
             [self stopTimer];
        }
        
    }
}
-(void)PubNubPublishMessage:(NSString*)message extras:(NSDictionary*)extras somessage:(SOMessage*)msg{
    
    UserDefault*userDefault=[[UserDefault alloc]init];
    User*user=[userDefault getUser];
    NSLog(@"self.chat%@",self.chat);
    {
        
        
        [self.chat setListener:[AppDelegate class]];
        
        [self.chat sendMessage:message toChannel:__currentChennalViewID withMetaData:extras OnCompletion:^(PNPublishStatus *sucess){
            
            NSLog(@"message successfully send");
            //            _currentChennal = self.channel;
            //            NSLog(@"%@",currentChannel);
        }OnError:^(PNPublishStatus *failed){
            
            NSLog(@"message failed to sende retry in progress");
            
        }];
    }
    
    
    
}



-(void)backButton{
    //  [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setUpPubNubChatApi{
    
    
    //
    //    if(!self.isGroupChatView){
    //
    //        self.channel = [NSString stringWithFormat:@"Private_%@",currentChannel];
    //
    //        //        [self.client subscribeToChannels: self.channelArray withPresence:YES];
    //
    //
    //    }else{
    //
    //        self.channel =self.currentChannelGroup;
    //
    //        //        [self addchannelsToGroup];
    //
    //        //        self.channel = [NSString stringWithFormat:@"Public_%@",self.group.groupId];
    //
    //        //        [self.client subscribeToChannels:@[self.channel] withPresence:YES];
    //
    //
    //    }
    //
    self.chat = [Chat sharedManager];
    
    //    self.chat.delegate = self;
    
    [self.chat setListener:self];
    
    [self.chat subscribeChannels];
    
    //   [self.chat getChatHistory:self.channel];
    
    
    
    
}

- (void)leavingBackgroundMode:(NSNotification*)notification
{
    Name=@"Session";
    //
    //    _publisher.publishVideo = YES;
    //    _currentSubscriber.subscribeToVideo = YES;
    //
    //    //now subscribe to any background connected streams
    //    for (OTStream *stream in backgroundConnectedStreams)
    //    {
    //        // create subscriber
    //        OTSubscriber *subscriber = [[OTSubscriber alloc]
    //                                    initWithStream:stream delegate:self];
    //        // subscribe now
    //        OTError *error = nil;
    //        [_session subscribe:subscriber error:&error];
    //        if (error)
    //        {
    //            [self showAlert:[error localizedDescription]];
    //        }
    //        // [subscriber release];
    //    }
    //    [backgroundConnectedStreams removeAllObjects];
}

- (void)stopTimer {
    if ( [timer isValid]) {
        [timer invalidate], timer=nil;
    }
}


@end
