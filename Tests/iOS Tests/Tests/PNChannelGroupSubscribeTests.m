//
//  PNChannelGroupSubscribeTests.m
//  PubNub Tests
//
//  Created by Jordan Zucker on 6/28/15.
//
//

#import <PubNub/PubNub.h>

#import "PNBasicSubscribeTestCase.h"

static NSString * const kPNChannelGroupTestsName = @"PNChannelGroupSubscribeTests";

@interface PNChannelGroupSubscribeTests : PNBasicSubscribeTestCase
@end

@implementation PNChannelGroupSubscribeTests

- (BOOL)isRecording{
    return NO;
}

- (NSArray *)channelGroups {
    return @[
             kPNChannelGroupTestsName
             ];
}

- (void)setUp {
    [super setUp];
    [self performVerifiedRemoveAllChannelsFromGroup:kPNChannelGroupTestsName withAssertions:nil];
    PNWeakify(self);
    [self performVerifiedAddChannels:@[@"a", @"b"] toGroup:kPNChannelGroupTestsName withAssertions:^(PNAcknowledgmentStatus *status) {
        PNStrongify(self);
        XCTAssertNotNil(status);
        XCTAssertFalse(status.isError);
        XCTAssertEqual(status.operation, PNAddChannelsToGroupOperation);
        XCTAssertEqual(status.category, PNAcknowledgmentCategory);
        XCTAssertEqual(status.statusCode, 200);
    }];
}

- (void)testSimpleSubscribeWithPresence {
    PNWeakify(self);
    self.didReceiveStatusAssertions = ^void (PubNub *client, PNSubscribeStatus *status) {
        PNStrongify(self);
        XCTAssertEqualObjects(self.client, client);
        XCTAssertNotNil(status);
        XCTAssertFalse(status.isError);
        XCTAssertEqual(status.category, PNConnectedCategory);
        NSArray *expectedChannelGroups = @[
                                           kPNChannelGroupTestsName,
                                           [kPNChannelGroupTestsName stringByAppendingString:@"-pnpres"]
                                           ];
        XCTAssertEqual(status.subscribedChannels.count, 0);
        XCTAssertEqualObjects([NSSet setWithArray:status.subscribedChannelGroups],
                              [NSSet setWithArray:expectedChannelGroups]);
        
        XCTAssertEqual(status.operation, PNSubscribeOperation);
        NSLog(@"timeToken: %@", status.currentTimetoken);
        XCTAssertEqualObjects(status.currentTimetoken, @14600786114532547);
        XCTAssertEqualObjects(status.currentTimetoken, status.data.timetoken);
        
    };
    self.didReceiveMessageAssertions = ^void (PubNub *client, PNMessageResult *message) {
        PNStrongify(self);
        XCTAssertEqualObjects(self.client, client);
        XCTAssertEqualObjects(client.uuid, message.uuid);
        XCTAssertNotNil(message.uuid);
        XCTAssertNil(message.authKey);
        XCTAssertEqual(message.statusCode, 200);
        XCTAssertTrue(message.TLSEnabled);
        XCTAssertEqual(message.operation, PNSubscribeOperation);
        NSLog(@"message:");
        NSLog(@"%@", message.data.message);
        XCTAssertNotNil(message.data);
        XCTAssertEqualObjects(message.data.message, @"********....... 8143 - 2016-04-07 18:23:32");
        XCTAssertEqualObjects(message.data.actualChannel, @"a");
        XCTAssertEqualObjects(message.data.subscribedChannel, kPNChannelGroupTestsName);
        XCTAssertEqualObjects(message.data.timetoken, @14600786124862238);
        [self.channelGroupSubscribeExpectation fulfill];
    };
    [self PNTest_subscribeToChannelGroups:[self channelGroups] withPresence:YES];
}

- (void)testSimpleSubscribeWithNoPresence {
    PNWeakify(self);
    self.didReceiveStatusAssertions = ^void (PubNub *client, PNSubscribeStatus *status) {
        PNStrongify(self);
        XCTAssertEqualObjects(self.client, client);
        XCTAssertNotNil(status);
        XCTAssertFalse(status.isError);
        XCTAssertEqual(status.category, PNConnectedCategory);
        NSArray *expectedChannelGroups = @[
                                           kPNChannelGroupTestsName
                                           ];
        XCTAssertEqual(status.subscribedChannels.count, 0);
        XCTAssertEqualObjects([NSSet setWithArray:status.subscribedChannelGroups],
                              [NSSet setWithArray:expectedChannelGroups]);
        
        XCTAssertEqual(status.operation, PNSubscribeOperation);
        NSLog(@"timeToken: %@", status.currentTimetoken);
        XCTAssertEqualObjects(status.currentTimetoken, @14600786111697900);
        XCTAssertEqualObjects(status.currentTimetoken, status.data.timetoken);
        
    };
    self.didReceiveMessageAssertions = ^void (PubNub *client, PNMessageResult *message) {
        PNStrongify(self);
        XCTAssertEqualObjects(self.client, client);
        XCTAssertEqualObjects(client.uuid, message.uuid);
        XCTAssertNotNil(message.uuid);
        XCTAssertNil(message.authKey);
        XCTAssertEqual(message.statusCode, 200);
        XCTAssertTrue(message.TLSEnabled);
        XCTAssertEqual(message.operation, PNSubscribeOperation);
        NSLog(@"message:");
        NSLog(@"%@", message.data.message);
        XCTAssertNotNil(message.data);
        // the string from this channel is absurd, should simplify at some point, but want to just keep cranking for now
        // cast to NSData to compare
        
        XCTAssertEqualObjects(message.data.message, @"*******........ 8142 - 2016-04-07 18:23:31");
        XCTAssertEqualObjects(message.data.actualChannel, @"a");
        XCTAssertEqualObjects(message.data.subscribedChannel, kPNChannelGroupTestsName);
        XCTAssertEqualObjects(message.data.timetoken, @14600786113072200);
        [self.channelGroupSubscribeExpectation fulfill];
    };
    [self PNTest_subscribeToChannelGroups:[self channelGroups] withPresence:NO];
}

@end