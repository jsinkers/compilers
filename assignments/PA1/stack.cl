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
    interpret(s: String): StackCommand { 
      if s = "+" then push(new PlusCommand) else 
      if s = "s" then push(new SwapCommand) else
      if s = "e" then push(new EvalCommand) else
      if s = "d" then push(new DisplayCommand) else
      if s = "x" then push(new StopCommand) else 
        let intCommand: IntCommand <- new IntCommand
          in { intCommand.setValue((new A2I).a2i(s));
            push(intCommand);
          }
      fi
      fi
      fi
      fi
      fi
    };
};

-- represents an integer added to the stack
class IntCommand inherits StackCommand {
    value: Int;

    evaluate(): StackCommand { self };

    setValue(newValue: Int): Int { value <- newValue };
};


class PlusCommand inherits StackCommand {
    -- evaluate(): StackCommand
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

