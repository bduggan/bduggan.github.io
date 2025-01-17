// chess.js
const PIECES = {
    K: 'K', Q: 'Q', R: 'R', B: 'B', N: 'N', P: 'P',
    k: 'k', q: 'q', r: 'r', b: 'b', n: 'n', p: 'p'
};

const FILES = 'abcdefgh';
const INITIAL_BOARD = [
    'rnbqkbnr',
    'pppppppp',
    '........',
    '........',
    '........',
    '........',
    'PPPPPPPP',
    'RNBQKBNR'
];

class Chess {
    constructor() {
        this.board = INITIAL_BOARD.map(row => [...row]);
        this.turn = 'w';
        this.selected = null;
        this.moves = [];
        this.enPassant = null;
        this.castling = { w: { k: true, q: true }, b: { k: true, q: true } };
        this.moveHistory = [];
        this.boardHistory = [];
        this.setupBoard();
        this.currentMove = -1;
        document.addEventListener('keydown', (e) => {
          if (e.key === 'ArrowLeft' && (this.currentMove > -1 || this.moveHistory.length > 0)) {
            this.navigateToMove(this.currentMove - 1);
          } else if (e.key === 'ArrowRight' && this.currentMove < this.moveHistory.length - 1) {
            this.navigateToMove(this.currentMove + 1);
          }
        });
    }

    navigateToMove(move) {
      if (move < -1 || move >= this.moveHistory.length) {
        return;
      }
      console.log(`navigate to move: ${move}`);
      this.currentMove = move;
      if (move === -1) {
        this.board = INITIAL_BOARD.map(row => [...row]);
        this.turn = 'w';
        this.selected = null;
        this.moves = [];
        this.enPassant = null;
        this.castling = { w: { k: true, q: true }, b: { k: true, q: true } };
        this.moveHistory = [];
        this.boardHistory = [];
      } else {
        move = move + 1;
        this.board = this.boardHistory[move].map(row => [...row]);
        this.turn = move % 2 === 0 ? 'w' : 'b';
        this.selected = null;
        // this.moves = [];
        this.enPassant = null;
        this.castling = { w: { k: true, q: true }, b: { k: true, q: true } };
        this.moveHistory = this.moveHistory.slice(0, move * 2);
        this.boardHistory = this.boardHistory.slice(0, move);
      }
      this.setupBoard();
    }

    setupBoard() {
        const board = document.getElementById('board');
        board.innerHTML = '';
        for (let r = 0; r < 8; r++) {
            for (let c = 0; c < 8; c++) {
                const square = document.createElement('div');
                square.className = `square ${(r + c) % 2 ? 'black' : 'white'}`;
                square.dataset.pos = `${r},${c}`;
                const piece = this.board[r][c];
                if (piece !== '.') {
                    square.dataset.piece = PIECES[piece];
                }
                square.onclick = () => this.handleClick(r, c);
                board.appendChild(square);
            }
        }
        document.getElementById('status').textContent = 
            `${this.turn === 'w' ? 'White' : 'Black'}'s turn`;
        this.updatePGN();
    }

    toPGN(fromR, fromC, toR, toC, capture) {
        const piece = this.board[fromR][fromC].toUpperCase();
        const from = FILES[fromC] + (8 - fromR);
        const to = FILES[toC] + (8 - toR);
        
        if (piece === 'K' && Math.abs(fromC - toC) === 2) {
            return toC > fromC ? 'O-O' : 'O-O-O';
        }
        
        return (piece === 'P' ? '' : piece) + 
               (capture ? 'x' : '') + 
               to;
    }

    updatePGN() {
        let pgn = '';
        for (let i = 0; i < this.moveHistory.length; i += 2) {
            const moveNum = Math.floor(i / 2) + 1;
            pgn += moveNum + '. ' + this.moveHistory[i];
            if (i + 1 < this.moveHistory.length) {
                pgn += ' ' + this.moveHistory[i + 1];
            }
            pgn += '\n';
        }
        document.getElementById('pgn').textContent = pgn;
    }

    isUpperCase(c) { return c === c.toUpperCase(); }

    handleClick(r, c) {
        const piece = this.board[r][c];
        if (!this.selected) {
            if (piece !== '.' && this.isUpperCase(piece) === (this.turn === 'w')) {
                this.selected = [r, c];
                this.moves = this.getValidMoves(r, c);
                this.highlight();
            }
        } else {
            const [sr, sc] = this.selected;
            if (this.moves.some(([mr, mc]) => mr === r && mc === c)) {
                this.makeMove(sr, sc, r, c);
            }
            this.selected = null;
            this.moves = [];
            this.highlight();
        }
    }

    highlight() {
        document.querySelectorAll('.square').forEach(sq => {
            sq.classList.remove('selected', 'valid-move');
        });
        if (this.selected) {
            const [r, c] = this.selected;
            document.querySelector(`[data-pos="${r},${c}"]`).classList.add('selected');
            this.moves.forEach(([mr, mc]) => {
                document.querySelector(`[data-pos="${mr},${mc}"]`)
                    .classList.add('valid-move');
            });
        }
    }

    getValidMoves(r, c) {
        const piece = this.board[r][c];
        const moves = [];
        const isWhite = this.isUpperCase(piece);
        const dir = isWhite ? -1 : 1;

        const addMove = (nr, nc) => {
            if (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
                const target = this.board[nr][nc];
                if (target === '.' || this.isUpperCase(target) !== isWhite) {
                    moves.push([nr, nc]);
                }
            }
        };

        const addSliding = (dirs) => {
            for (const [dr, dc] of dirs) {
                let nr = r + dr, nc = c + dc;
                while (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
                    const target = this.board[nr][nc];
                    if (target === '.') {
                        moves.push([nr, nc]);
                    } else {
                        if (this.isUpperCase(target) !== isWhite) {
                            moves.push([nr, nc]);
                        }
                        break;
                    }
                    nr += dr;
                    nc += dc;
                }
            }
        };

        switch (piece.toUpperCase()) {
            case 'P':
                if (this.board[r + dir][c] === '.') {
                    moves.push([r + dir, c]);
                    if ((isWhite && r === 6) || (!isWhite && r === 1)) {
                        if (this.board[r + 2 * dir][c] === '.') {
                            moves.push([r + 2 * dir, c]);
                        }
                    }
                }
                for (const dc of [-1, 1]) {
                    const nr = r + dir, nc = c + dc;
                    if (nr >= 0 && nr < 8 && nc >= 0 && nc < 8) {
                        const target = this.board[nr][nc];
                        if (target !== '.' && this.isUpperCase(target) !== isWhite) {
                            moves.push([nr, nc]);
                        }
                        if (this.enPassant && nr === this.enPassant[0] && nc === this.enPassant[1]) {
                            moves.push([nr, nc]);
                        }
                    }
                }
                break;

            case 'N':
                for (const [dr, dc] of [[2,1],[2,-1],[-2,1],[-2,-1],[1,2],[1,-2],[-1,2],[-1,-2]]) {
                    addMove(r + dr, c + dc);
                }
                break;

            case 'B':
                addSliding([[1,1],[1,-1],[-1,1],[-1,-1]]);
                break;

            case 'R':
                addSliding([[0,1],[0,-1],[1,0],[-1,0]]);
                break;

            case 'Q':
                addSliding([[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,1],[-1,-1]]);
                break;

            case 'K':
                for (const [dr, dc] of [[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,1],[-1,-1]]) {
                    addMove(r + dr, c + dc);
                }
                if (this.castling[this.turn]) {
                    if (this.castling[this.turn].k && 
                        this.board[r][5] === '.' && 
                        this.board[r][6] === '.') {
                        moves.push([r, 6]);
                    }
                    if (this.castling[this.turn].q && 
                        this.board[r][3] === '.' && 
                        this.board[r][2] === '.' && 
                        this.board[r][1] === '.') {
                        moves.push([r, 2]);
                    }
                }
                break;
        }

        return moves;
    }

    makeMove(fromR, fromC, toR, toC) {
        const piece = this.board[fromR][fromC];
        const isWhite = this.isUpperCase(piece);
        const capture = this.board[toR][toC] !== '.';

        if (piece.toUpperCase() === 'P' && this.enPassant && 
            toR === this.enPassant[0] && toC === this.enPassant[1]) {
            this.board[fromR][toC] = '.';
        }

        this.enPassant = null;
        if (piece.toUpperCase() === 'P' && Math.abs(fromR - toR) === 2) {
            this.enPassant = [fromR + (toR - fromR)/2, fromC];
        }

        if (piece.toUpperCase() === 'K') {
            if (Math.abs(fromC - toC) === 2) {
                const rookFromC = toC > fromC ? 7 : 0;
                const rookToC = toC > fromC ? 5 : 3;
                this.board[fromR][rookToC] = this.board[fromR][rookFromC];
                this.board[fromR][rookFromC] = '.';
            }
            this.castling[this.turn] = { k: false, q: false };
        }

        if (piece.toUpperCase() === 'R') {
            if (fromC === 0) this.castling[this.turn].q = false;
            if (fromC === 7) this.castling[this.turn].k = false;
        }

        this.moveHistory.push(this.toPGN(fromR, fromC, toR, toC, capture));
        this.boardHistory.push(this.board.map(row => [...row]));0
        
        this.board[toR][toC] = this.board[fromR][fromC];
        this.board[fromR][fromC] = '.';

        this.turn = this.turn === 'w' ? 'b' : 'w';
        this.currentMove = this.moveHistory.length - 1;
        console.log(`currentMove: ${this.currentMove}`);
        this.setupBoard();
    }
}

new Chess();
