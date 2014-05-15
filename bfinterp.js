function disp(txt) {
    var stdout = document.getElementById("stdout");

    //There should be something to manage \n

    stdout.innerHTML += txt;
}

function getkey() {
    var stdin = document.getElementById("stdin");
    var key;

    stdin.addEventListener('keyDown', function(e) {
        alert(e.type);
        key = e.keycCde;
    }, false);
    return key;
}

function interpret(){
    var stdin = document.getElementById("stdin");
    var mem = [];
    var memCur = 0;
    var prog = document.getElementById("prog").value;
    var progCur = 0;
    var loops = [];

    for (var i=0; i<30000 ; i++) {
        mem[i] = 0;
    }
    stdout.innerHTML = "";

    var chr, inputCur = 0, input = "";
    while (progCur != prog.length) {
        chr = prog[progCur];

        switch (chr) {
            case "+":
                mem[memCur] = (mem[memCur] + 1) % 256;
                break;

            case "-":
                mem[memCur] = (mem[memCur] - 1) % 256;
                break;

            case ">":
                memCur = (memCur + 1) % 30000;
                break;

            case "<":
                memCur = (memCur - 1) % 30000;
                break;

            case ".":
                disp(String.fromCharCode(mem[memCur]));
                break;

            case ",":
                mem[memCur] = getkey();
                break;

            case "[":
                loops.push(progCur);
                break;

            case "]":
                if (mem[memCur] != 0) {
                    progCur = loops.pop(progCur) - 1;
                }
                else {
                    loops.pop(progCur);
                }
                break;
        }

        progCur++;
    }
}
