package persistence;

import core.*;

interface IStorage {
    function getSavedBoard():Board;
    function hasSavedBoard():Bool;
    function saveBoard(board:Board):Void;
}