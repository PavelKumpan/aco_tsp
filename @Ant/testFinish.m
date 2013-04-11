function [this, completed] = testFinish(this, finish)
    if(this.node == finish)
        this.alive = 0;
        completed = 1;
    else
        completed = 0;
    end;
end

