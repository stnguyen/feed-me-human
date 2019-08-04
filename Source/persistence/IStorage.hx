package persistence;

import core.*;

interface IStorage {
    function getSavedBoard():Board;
    function saveBoard(board:Board):Void;
}