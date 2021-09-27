(*
 *  CS164 Fall 94
 *
 *  Programming Assignment 1
 *    Implementation of a simple stack machine.
 *
 *  Skeleton file
 *)

class Main inherits IO {
   head: StackCommand;
   string : String;
   stack: Stack <- new Stack;
   main() : Object {
      while stack.continue() loop 
      {
          -- prompt
          out_string("\n>");
          -- read input
          string <- in_string();
          stack.interpret(string);
          -- 
          --false
      }
      pool
   };
};

class StackCommand {
    next: StackCommand;

    parentInit(newNext: StackCommand): StackCommand {
        next <- newNext
    };

    init(newNext: StackCommand): StackCommand {
         next <- newNext
    };

    --evaluate(): Int { 0}

    continue(): Bool { true };

    setNext(newNext: StackCommand): StackCommand { next <- newNext };
};

class Stack inherits IO {
    head : StackCommand;

    -- pop a command from the stack
    --pop(): StackCommand {};
    --pop(): Int { };
        -- popped: StackCommand;
        (* if isvoid head then 
         * {
         *     popped <- head;
         *     head <- head.next;
         *     
         * };
         * else popped
         * fi
         *)
        -- s: StackCommand;
    --}

    -- push a new command onto the stack.  return the current head
    push(newCmd: StackCommand): StackCommand {
        {
            newCmd.init(head);
            head <- newCmd;
        }
    };

    continue(): Bool { 
        if isvoid head then true else head.continue() fi
    };
    
    -- interpret the input string and update the stack
    interpret(s: String): Object { 
      if s = "a" then out_string(s) else 
      if s = "x" then push(new StopCommand) else false
      fi
      fi
    };
};

-- represents an integer added to the stack
class IntCommand inherits StackCommand {
    value: Int;

    evaluate(): Int {
        value
    };

    setValue(newValue: Int): Int { value <- newValue };
    -- init(newNext: StackCommand, newValue: Int): StackCommand 
    -- {
    --     {
    --         -- seems like overridden methods need to match arguments of parent
    --         parentInit(newNext);
    --         --self@StackCommand.init(newNext, dummy);
    --         value <- newValue;
    --         self;
    --     }
    -- };
};


class PlusCommand inherits StackCommand {

};

class SwapCommand inherits StackCommand {

};

class EvalCommand inherits StackCommand {

};

class DisplayCommand inherits StackCommand {

};

class StopCommand inherits StackCommand {
    continue(): Bool { false };
};

