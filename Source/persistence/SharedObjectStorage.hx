package persistence;

import core.*;
import openfl.net.SharedObject;

class SharedObjectStorage implements IStorage {
    var so:SharedObject;

    public function new() {
        so = SharedObject.getLocal("SharedObjectStorage");
    }

    public function getSavedBoard():Board {
        if (!hasSavedBoard()) return null;
        var serializedBoard = so.data.board;
        return BoardSerializer.deserialize(serializedBoard);
    }
    
    public function hasSavedBoard():Bool {
        return so.data.board != null;
    }

    public function saveBoard(board:Board):Void {
        if (board == null) {
            so.data.board = null;
        } else {
            var serializedBoard = BoardSerializer.serialize(board);
            so.data.board = serializedBoard;
        }
        so.flush();
    }
}