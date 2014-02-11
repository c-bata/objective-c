//
//  PNMessagingChannel.h
//  pubnub
//
//  This channel instance is required for messages exchange between client and PubNub service:
//    - channels messages (subscribe)
//    - channels presence events
//    - leave
//
//  Notice: don't try to create more than one messaging channel on MacOS
//
//
//  Created by Sergey Mamontov on 12/12/12.
//
//

#import "PNConnectionChannel.h"
#import "PNMessageChannelDelegate.h"


#pragma mark Class forward

@class PNChannel;


@interface PNMessagingChannel : PNConnectionChannel


#pragma mark - Properties

// Stores reference on delegate which is interested in messaging channel events
@property (nonatomic, pn_desired_weak) id<PNMessageChannelDelegate> messagingDelegate;


#pragma mark - Class methods

/**
 * Return reference on configured messages communication channel with specified delegate
 */
+ (PNMessagingChannel *)messageChannelWithDelegate:(id<PNConnectionChannelDelegate>)delegate;


#pragma mark - Instance methods

#pragma mark - Connection management

/**
 * This method allow to disconnect communication channel from remote PubNub services and perform channel
 * reset if required
 */
- (void)disconnectWithReset:(BOOL)shouldResetCommunicationChannel;


#pragma mark - Channels management

- (NSArray *)subscribedChannels;
- (NSArray *)fullSubscribedChannelsList;

- (BOOL)isSubscribedForChannel:(PNChannel *)channel;

/**
 Method will initiate subscription on specified set of channels. This request will add provided channels set to the
 list of channels on which client already subscribed.

 @param channels
 List of \b PNChannel instances on which it should subscribe.

 @note By default this method will generate presence event on channels on which client already subscribed.
 */
- (void)subscribeOnChannels:(NSArray *)channels;

/**
 Method will initiate subscription on specified set of channels. This request will add provided channels set to the
 list of channels on which client already subscribed.

 @code
 @endcode
 This method extends \a -subscribeOnChannels: and allow to specify whether presence event should be generated or not.

 @param channels
 List of \b PNChannel instances on which it should subscribe.

 @param withPresenceEvent
 If set to \c YES than it will send \a 'leave' presence event on channels (if subscribed at some) and than generate
 \a 'join' event for old and new one channels.

 */
- (void)subscribeOnChannels:(NSArray *)channels withPresenceEvent:(BOOL)withPresenceEvent;

/**
 Method will initiate subscription on specified set of channels. This request will add provided channels set to the
 list of channels on which client already subscribed.

 @code
 @endcode
 This method extends \a -subscribeOnChannels: and allow to specify whether presence event should be generated or not.

 @param channels
 List of \b PNChannel instances on which it should subscribe.

 @param withPresenceEvent
 If set to \c YES than it will send \a 'leave' presence event on channels (if subscribed at some) and than generate
 \a 'join' event for old and new one channels.

 @param clientState
 \b NSDictionary instance with list of parameters which should be bound to the client.
 */
- (void)subscribeOnChannels:(NSArray *)channels withPresenceEvent:(BOOL)withPresenceEvent
             andClientState:(NSDictionary *)clientState;

/**
 * Will unsubscribe from all channels with which it communicate now. This method also will trigger 'leave'
 * presence event if withPresenceEvent flag is set to 'YES'
 *
 * @return Returns list of channels from which client will unsubscribe
 */
- (NSArray *)unsubscribeFromChannelsWithPresenceEvent:(BOOL)withPresenceEvent;

/**
 * Will unsubscribe client from set of channels. Specified set of channels will be removed from the list of
 * subscribed channels. Leave event will be sent on provided list of channels.
 */
- (void)unsubscribeFromChannels:(NSArray *)channels;

/**
 * Same function as -unsubscribeFromChannels: but also allow to specify whether 'leave' presence event should be
 * generated or not.
 */
- (void)unsubscribeFromChannels:(NSArray *)channels withPresenceEvent:(BOOL)withPresenceEvent;


#pragma mark - Presence observation management

- (BOOL)isPresenceObservationEnabledForChannel:(PNChannel *)channel;
- (void)enablePresenceObservationForChannels:(NSArray *)channels;
- (void)disablePresenceObservationForChannels:(NSArray *)channels;

#pragma mark -


@end
