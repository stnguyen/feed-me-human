package persistence;

import core.*;
import openfl.net.SharedObject;

class LocalStorage implements IStorage {
    var so:SharedObject;

    public function new() {
        so = SharedObject.getLocal("LocalStorage");
    }

    public function getSavedBoard():Board {
        var serializedBoard = so.data.board;
        return serializedBoard != null ? BoardSerializer.deserialize(serializedBoard) : null;
    }

    public function saveBoard(board:Board):Void {
        var serializedBoard = BoardSerializer.serialize(board);
        so.data.board = serializedBoard;
        so.flush();
    }
}