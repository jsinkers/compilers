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
      while stack.getContinue() loop 
      {
          -- prompt
          out_string(">");
          -- read input
          string <- in_string();
          stack.interpret(string);
      }
      pool
   };
};

class StackCommand inherits IO {
    next: StackCommand;
    a2i: A2I <- new A2I;

    parentInit(newNext: StackCommand): StackCommand {
        next <- newNext
    };

    init(newNext: StackCommand): StackCommand {
         next <- newNext
    };

    evaluate(): StackCommand { next };


    setNext(newNext: StackCommand): StackCommand { next <- newNext };

    getNext(): StackCommand { next };

    print(): Object { new Object};

    -- pop item off stack. return popped item
    pop(): StackCommand { 
        let popped: StackCommand <- next in {
            next <- next.getNext();
            popped;
        }
    };

    push(newCmd: StackCommand): StackCommand {
        {
            newCmd.init(next);
            next <- newCmd;
        }
    };
};

class Stack inherits IO {
    head : StackCommand;
    continue: Bool <- true;

    getContinue(): Bool { continue };

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

    -- interpret the input string and update the stack
    interpret(s: String): StackCommand { 
      if s = "+" then push(new PlusCommand) else 
      if s = "s" then push(new SwapCommand) else
      if s = "e" then { head <- head.evaluate(); } else
      if s = "d" then { print(); head; } else
      if s = "x" then { continue <- false; head; } else 
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

    -- print the stack
    print(): Object {
        let n: StackCommand <- head in 
        while isvoid n = false
        loop {
            n.print();
            n <- n.getNext();
        }
        pool
        
    };
};

-- represents an integer added to the stack
class IntCommand inherits StackCommand {
    value: Int;

    evaluate(): StackCommand { self };

    setValue(newValue: Int): Int { value <- newValue };

    print(): Object {
        (new IO).out_string(a2i.i2a(value).concat("\n"))
    };
};


class PlusCommand inherits StackCommand {
    evaluate(): StackCommand { 
        -- pop off first command
        --let sc1: StackCommand <- next, sc2: StackCommand <- next.getNext() 
        -- pop off second command
        next
    };

    print(): Object {
        (new IO).out_string("+\n")
    };
};

class SwapCommand inherits StackCommand {
    evaluate(): StackCommand {
        let sc1: StackCommand, sc2: StackCommand in {
            sc1 <- pop();
            sc2 <- pop();
            push(sc1);
            push(sc2);
            next;
        }
    };

    print(): Object {
        out_string("s\n")
    };
};

