extends Behavior
class_name EatBehavior


enum EatBehaviorState {
    MOVE_TO,
    DROP_HELD,
    PICK_UP,
    EAT,
    COMPLETE
}

var state := EatBehaviorState.MOVE_TO